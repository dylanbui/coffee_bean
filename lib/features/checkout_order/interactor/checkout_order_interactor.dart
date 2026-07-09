import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_service.dart';
import 'package:coffee_bean/data/model/payment_domain.dart';
import 'package:coffee_bean/data/model/response/promotion/coupon_model.dart';
import 'package:coffee_bean/data/repository/payment_domain_repository.dart';
import 'package:coffee_bean/features/checkout_order/checkout_order_common.dart';
import 'package:coffee_bean/features/checkout_order/interactor/checkout_order_event_state.dart';
import 'package:coffee_bean/features/checkout_order/checkout_order_router.dart';
import 'package:coffee_bean/scenes/my_profile_features/coupon_list/interactor/coupon_list_interactor.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_flow.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_helper.dart';
import 'package:db_core/db_core.dart';


class CheckoutOrderInteractor extends CubitInteractor<CheckoutOrderRoutable, CheckoutOrderState>
    with _CheckoutOrderPaymentMixin, _CheckoutOrderLoginMixin, _CheckoutOrderCouponMixin
    implements CouponListListener, UserAuthFlowListener {
  
  final CheckoutItemContract checkoutItem;
  final PaymentDomainRepository paymentRepo = locator<PaymentDomainRepository>();

  CheckoutOrderInteractor(CheckoutOrderRoutable router, this.checkoutItem) 
      : super(CheckoutOrderState(checkoutItem: checkoutItem), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadInitialData();

    // Lắng nghe thay đổi giá từ options
    checkoutItem.totalOptionsAmountNotifier.addListener(_onPriceOptionsChanged);
    // Lắng nghe trạng thái hợp lệ từ options
    checkoutItem.isValidNotifier.addListener(_onValidationOptionsChanged);

    // Lấy giá trị ban đầu
    _onPriceOptionsChanged();
    _onValidationOptionsChanged();

    // Lắng nghe sự kiện login thành công để reload UI giống order_confirmation
    collect(
      locator<DbEventBus>().on<UserLoginSuccessEvent>().listen((event) {
        _loadInitialData();
        emit(state.copyWith());
      }),
    );
  }

  @override
  void onWillResignActive() {
    checkoutItem.totalOptionsAmountNotifier.removeListener(_onPriceOptionsChanged);
    checkoutItem.isValidNotifier.removeListener(_onValidationOptionsChanged);
    checkoutItem.dispose();
    super.onWillResignActive();
  }

  void _onPriceOptionsChanged() {
    emit(state.copyWith(optionsAmount: checkoutItem.totalOptionsAmountNotifier.value));
  }

  void _onValidationOptionsChanged() {
    emit(state.copyWith(isOrderButtonEnabled: checkoutItem.isValidNotifier.value));
  }

  Future<void> _loadInitialData() async {
    final user = UserManager().userInfo;
    emit(state.copyWith(
      uiStatus: state.uiStatus.copyWith(isLoading: false),
      userPoints: (user?.point ?? 0).toDouble(),
    ));
  }

  void selectCoupon() {
    router?.openCouponList(this);
  }

  void updatePaymentMethod(String methodKey) {
    emit(state.copyWith(preferences: state.preferences.copyWith(paymentMethodKey: methodKey)));
  }

  void updateNote(String note) {
    emit(state.copyWith(preferences: state.preferences.copyWith(note: note)));
  }

  void togglePoints(bool use) {
    if (use) {
      final maxPointsNeeded = state.baseAmount / state.pointConversionRate;
      final used = state.userPoints > maxPointsNeeded ? maxPointsNeeded : state.userPoints;
      emit(state.copyWith(usedPoints: used));
    } else {
      emit(state.copyWith(usedPoints: 0));
    }
  }

  void doLogin() {
    router?.doLoginFlow(this);
  }
}

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
  @override
  void onCouponSelected(CouponModel coupon) {
    double discount = coupon.discountValue;
    if (coupon.discountTypeStr == "%") {
      discount = state.baseAmount * (discount / 100);
    }

    emit(state.copyWith(
      promotion: state.promotion.copyWith(
        selectedCoupon: coupon.title,
        couponDiscount: discount,
      ),
    ));
  }

  @override
  void onNoCouponSelected() {
    // Không dùng copyWith vì copyWith của CheckoutPromotion dùng ?? nên không thể set null
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
