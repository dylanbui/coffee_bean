import 'package:coffee_bean/config/app_pref.dart';
import 'package:coffee_bean/data/local/live_service/cart_service.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:coffee_bean/scenes/coupon_list/interactor/coupon_list_interactor.dart';
import 'package:coffee_bean/scenes/order_confirmation/interactor/order_confirmation_event_state.dart';
import 'package:coffee_bean/scenes/order_confirmation/order_confirmation_router.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_flow.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_helper.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/commons_constants.dart';
import 'package:db_core/services/event_bus.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/utils/locator.dart';
import 'package:db_core/utils/logger.dart';
import 'package:flutter/material.dart';

class OrderConfirmationInteractor extends CubitInteractor<OrderConfirmationRoutable, OrderConfirmationState>
    with _OrderConfirmationPaymentMixin, _OrderConfirmationLoginMixin, _CouponListListenerMixin
    implements CouponListListener, UserAuthFlowListener {
  final CartService _cartService = locator<CartService>();
  final DatabaseService _dbService = locator<DatabaseService>();

  OrderConfirmationInteractor(OrderConfirmationRoutable router) : super(OrderConfirmationState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadInitialData();

    // Lắng nghe sự kiện login thành công để reload UI
    collect(
      locator<DbEventBus>().on<UserLoginSuccessEvent>().listen((event) {
        emit(state.copyWith());
      }),
    );
  }

  Future<void> _loadInitialData() async {
    final selectedStoreId = AppPrefs().getSelectedStoreId();
    TblStore? store;

    if (selectedStoreId != null) {
      store = await _dbService.isar.tblStores.filter().serverIdEqualTo(selectedStoreId).findFirst();
    }

    store ??= await _dbService.isar.tblStores.where().findFirst();

    final cartItems = _cartService.currentItems;

    emit(state.copyWith(
      uiStatus: state.uiStatus.copyWith(isLoading: false),
      selectedStore: store,
      cartItems: cartItems,
    ));
  }

  void updateDeliveryMethod(DeliveryMethod method) {
    emit(state.copyWith(preferences: state.preferences.copyWith(deliveryMethod: method)));
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

  void doLogin() {
    router?.doLoginFlow(this);
  }
}

// region Payment mixin
mixin _OrderConfirmationPaymentMixin on CubitInteractor<OrderConfirmationRoutable, OrderConfirmationState> {
  Future<void> processPayment() async {
    if (state.status == OrderConfirmationStatus.processing) return;
    if (!UserManager().isLogin) return;

    emit(state.copyWith(
      status: OrderConfirmationStatus.processing,
      uiStatus: state.uiStatus.copyWith(processingMessage: 'PAYMENT_PROCESSING'), // Sử dụng Key
    ));

    await Future.delayed(const Duration(seconds: 3));

    final cartService = locator<CartService>();
    await cartService.clearCart();

    emit(state.copyWith(
      status: OrderConfirmationStatus.success,
      orderNumber: '#CB${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
    ));
  }

  void retryPayment() {
    emit(state.copyWith(status: OrderConfirmationStatus.confirming));
  }
}
// endregion

// region Auth mixin
mixin _OrderConfirmationLoginMixin on CubitInteractor<OrderConfirmationRoutable, OrderConfirmationState>
    implements UserAuthFlowListener {
  @override
  void onAuthFlowSuccess(UserSession userData) {
    // Kích hoạt thông báo thành công qua Key
    emit(state.copyWith(
      uiStatus: state.uiStatus.copyWith(successMessageKey: "LOGIN_SUCCESS"),
    ));
    // Reset Key ngay lập tức
    emit(state.copyWith(
      uiStatus: state.uiStatus.copyWith(successMessageKey: null),
    ));

    locator<DbEventBus>().fire(UserLoginSuccessEvent(userData));
  }

  @override
  void onAuthFlowCancelled(DbError error) {}
}
// endregion

// region Coupon mixin
mixin _CouponListListenerMixin on CubitInteractor<OrderConfirmationRoutable, OrderConfirmationState>
    implements CouponListListener {
  @override
  void onCouponSelected(CouponModel coupon) {
    double discount = coupon.discountValue;
    if (coupon.discountType == "%") {
      discount = state.subtotal * (discount / 100);
    }

    emit(state.copyWith(
      promotion: state.promotion.copyWith(
        selectedCoupon: coupon.title,
        couponDiscount: discount,
      ),
    ));
  }

  @override
  void onNoCouponSelected() {}
}
// endregion
