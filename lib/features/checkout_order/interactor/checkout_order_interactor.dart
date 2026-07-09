import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_service.dart';
import 'package:coffee_bean/data/model/payment_domain.dart';
import 'package:coffee_bean/data/model/request/trade/order_settlement_request.dart';
import 'package:coffee_bean/data/model/response/promotion/coupon_model.dart';
import 'package:coffee_bean/data/repository/payment_domain_repository.dart';
import 'package:coffee_bean/data/repository/trade_repository.dart';
import 'package:coffee_bean/features/cart_workflow/cart_checkout_contract.dart';
import 'package:coffee_bean/features/checkout_order/checkout_order_common.dart';
import 'package:coffee_bean/features/checkout_order/interactor/checkout_order_event_state.dart';
import 'package:coffee_bean/features/checkout_order/checkout_order_router.dart';
import 'package:coffee_bean/scenes/my_profile_features/coupon_list/interactor/coupon_list_interactor.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_flow.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_helper.dart';
import 'package:db_core/db_core.dart';


class CheckoutOrderInteractor extends CubitInteractor<CheckoutOrderRoutable, CheckoutOrderState>
    with _CheckoutOrderPaymentMixin, _CheckoutOrderLoginMixin, _CheckoutOrderCouponMixin, _CheckoutOrderSettlementMixin
    implements CouponListListener, UserAuthFlowListener {
  
  final CheckoutItemContract checkoutItem;
  final PaymentDomainRepository paymentRepo = locator<PaymentDomainRepository>();
  final TradeRepository tradeRepo = locator<TradeRepository>();

  CheckoutOrderInteractor(CheckoutOrderRoutable router, this.checkoutItem) 
      : super(CheckoutOrderState(checkoutItem: checkoutItem), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadInitialData();

    // Lắng nghe thay đổi giá từ options (vẫn giữ để tương thích nếu cần)
    checkoutItem.totalOptionsAmountNotifier.addListener(_onPriceOptionsChanged);
    // Lắng nghe trạng thái hợp lệ từ options
    checkoutItem.isValidNotifier.addListener(_onValidationOptionsChanged);

    // Bổ sung: Lắng nghe thay đổi cụ thể để trigger Settlement
    if (checkoutItem is AppCartCheckoutContract) {
      final cartContract = checkoutItem as AppCartCheckoutContract;
      cartContract.deliveryMethodNotifier.addListener(_onDeliveryMethodChanged);
    }

    // Lấy giá trị ban đầu
    _onPriceOptionsChanged();
    _onValidationOptionsChanged();
    _fetchSettlementData(); // Gọi settlement lần đầu

    // Lắng nghe sự kiện login thành công để reload UI giống order_confirmation
    collect(
      locator<DbEventBus>().on<UserLoginSuccessEvent>().listen((event) {
        _loadInitialData();
        _fetchSettlementData();
        emit(state.copyWith());
      }),
    );
  }

  @override
  void onWillResignActive() {
    checkoutItem.totalOptionsAmountNotifier.removeListener(_onPriceOptionsChanged);
    checkoutItem.isValidNotifier.removeListener(_onValidationOptionsChanged);
    
    if (checkoutItem is AppCartCheckoutContract) {
      (checkoutItem as AppCartCheckoutContract).deliveryMethodNotifier.removeListener(_onDeliveryMethodChanged);
    }

    checkoutItem.dispose();
    super.onWillResignActive();
  }

  void _onPriceOptionsChanged() {
    emit(state.copyWith(optionsAmount: checkoutItem.totalOptionsAmountNotifier.value));
  }

  void _onValidationOptionsChanged() {
    emit(state.copyWith(isOrderButtonEnabled: checkoutItem.isValidNotifier.value));
  }

  void _onDeliveryMethodChanged() {
    _fetchSettlementData();
  }

  Future<void> _loadInitialData() async {
    final user = UserManager().userInfo;
    emit(state.copyWith(
      uiStatus: state.uiStatus.copyWith(isLoading: false),
      userPoints: (user?.point ?? 0).toDouble(),
    ));
  }

  void updatePaymentMethod(String methodKey) {
    emit(state.copyWith(preferences: state.preferences.copyWith(paymentMethodKey: methodKey)));
  }

  void updateNote(String note) {
    emit(state.copyWith(preferences: state.preferences.copyWith(note: note)));
  }

  void togglePoints(bool use) {
    // Với Server-driven, ta chỉ cần toggle flag và gọi API
    _fetchSettlementData(usePoints: use);
  }

  void doLogin() {
    router?.doLoginFlow(this);
  }
}

// region Settlement Mixin
mixin _CheckoutOrderSettlementMixin on CubitInteractor<CheckoutOrderRoutable, CheckoutOrderState> {
  TradeRepository get tradeRepo;
  CheckoutItemContract get checkoutItem;

  int? _selectedCouponId;
  bool _usePoints = false;

  Future<void> _fetchSettlementData({bool? usePoints, int? couponId, bool clearCoupon = false}) async {
    if (usePoints != null) _usePoints = usePoints;
    if (clearCoupon) {
      _selectedCouponId = null;
    } else if (couponId != null) {
      _selectedCouponId = couponId;
    }

    emit(state.copyWith(uiStatus: state.uiStatus.copyWith(isLoading: true)));

    // 1. Build items from contract
    final List<OrderItemRequest> items = [];
    final extraData = checkoutItem.extraData;
    if (extraData['items'] is List) {
      for (var item in (extraData['items'] as List)) {
        items.add(OrderItemRequest(
          skuId: item['sku_id'],
          count: item['quantity'],
          cartId: item['cart_id'], // Nếu có
        ));
      }
    }

    // 2. Build Request
    int deliveryType = 2; // Mặc định là Tự đến lấy/Tại quán (Pickup/At Store)
    if (checkoutItem is AppCartCheckoutContract) {
      // Trong mô hình Coffee Bean: Cả DineIn và TakeAway đều thuộc nhóm Self-pickup tại Store (Type 2)
      // Nếu sau này có Shipping tận nhà mới dùng Type 1
      deliveryType = 2;
    }

    final request = OrderSettlementRequest(
      items: items,
      pointStatus: _usePoints,
      deliveryType: deliveryType,
      couponId: _selectedCouponId,
      pickUpStoreId: extraData['store_id'] as int?,
    );

    // 3. Call API
    final result = await tradeRepo.getSettlementInfo(request);

    if (result case DbSuccess(:final data)) {
      emit(state.copyWith(
        settlement: data,
        uiStatus: state.uiStatus.copyWith(isLoading: false),
        usedPoints: _usePoints ? (data.usePoint ?? 0).toDouble() : 0,
      ));
    } else if (result case DbFailure(:final error)) {
      emit(state.copyWith(
        uiStatus: state.uiStatus.copyWith(
          isLoading: false,
          errorMessage: error.message,
        ),
      ));
    }
  }
}
// endregion

// region Payment mixin (Clone logic from order_confirmation)
mixin _CheckoutOrderPaymentMixin on CubitInteractor<CheckoutOrderRoutable, CheckoutOrderState> {
  Future<void> processPayment() async {
    if (state.status == CheckoutOrderStatus.processing) return;
    if (!UserManager().isLogin) return;

    emit(state.copyWith(
      status: CheckoutOrderStatus.processing,
      uiStatus: state.uiStatus.copyWith(processingMessage: 'PAYMENT_PROCESSING'),
    ));

    // Giả lập xử lý thanh toán thực tế dựa trên contract
    await Future.delayed(const Duration(seconds: 3));

    await UserService().refreshCounters();

    emit(state.copyWith(
      status: CheckoutOrderStatus.success,
      orderNumber: '#CB${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
    ));
  }

  void retryPayment() {
    emit(state.copyWith(status: CheckoutOrderStatus.confirming));
  }
}
// endregion

// region Auth mixin (Clone logic from order_confirmation)
mixin _CheckoutOrderLoginMixin on CubitInteractor<CheckoutOrderRoutable, CheckoutOrderState>
    implements UserAuthFlowListener {
  @override
  void onAuthFlowCompleted(AuthResult result) {
    if (result case LoginSuccess(:final session) || RegisterSuccess(:final session)) {
      emit(state.copyWith(
        uiStatus: state.uiStatus.copyWith(successMessageKey: "LOGIN_SUCCESS"),
      ));
      emit(state.copyWith(
        uiStatus: state.uiStatus.copyWith(successMessageKey: null),
      ));
      locator<DbEventBus>().fire(UserLoginSuccessEvent(session));
    }
  }

  @override
  void onAuthFlowCancelled(DbError error) {}
}
// endregion

// region Coupon mixin (Clone logic from order_confirmation)
mixin _CheckoutOrderCouponMixin on CubitInteractor<CheckoutOrderRoutable, CheckoutOrderState>
    implements CouponListListener {
  
  void selectCoupon() {
    router?.openCouponList(this);
  }

  @override
  void onCouponSelected(CouponModel coupon) {
    // Với Server-driven, ta không tự tính discount nữa mà gọi API Settlement
    if (this is _CheckoutOrderSettlementMixin) {
      (this as _CheckoutOrderSettlementMixin)._fetchSettlementData(couponId: coupon.id);
    }
    
    // Vẫn lưu title để hiển thị UI nhanh (nếu cần)
    emit(state.copyWith(
      promotion: state.promotion.copyWith(
        selectedCoupon: coupon.title,
      ),
    ));
  }

  @override
  void onNoCouponSelected() {
    if (this is _CheckoutOrderSettlementMixin) {
      (this as _CheckoutOrderSettlementMixin)._fetchSettlementData(clearCoupon: true);
    }

    emit(state.copyWith(
      promotion: CheckoutPromotion(
        selectedCoupon: null,
        couponDiscount: 0,
        usedPoints: state.promotion.usedPoints,
        pointsDiscount: state.promotion.pointsDiscount,
      ),
    ));
  }
}
// endregion
