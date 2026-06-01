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

    // Lắng nghe sự kiện login thành công từ toàn hệ thống thông qua collect
    collect(
      locator<DbEventBus>().on<UserLoginSuccessEvent>().listen((event) {
        emit(OrderConfirmationLoginNotifyState(state));
      }),
    );
  }

  Future<void> _loadInitialData() async {
    final selectedStoreId = AppPrefs().getSelectedStoreId();
    print("DEBUG: OrderConfirmationInteractor - Loading data for StoreID: $selectedStoreId");
    TblStore? store;

    if (selectedStoreId != null) {
      store = await _dbService.isar.tblStores.filter().serverIdEqualTo(selectedStoreId).findFirst();
    }

    // Fallback to first store if no store is saved or found
    if (store == null) {
      iLog("DEBUG: OrderConfirmationInteractor - Store not found for ID $selectedStoreId, falling back to first store");
      store = await _dbService.isar.tblStores.where().findFirst();
    }

    if (store == null) {
      iLog("DEBUG: OrderConfirmationInteractor - CRITICAL - No store found in database at all!");
    } else {
      iLog("DEBUG: OrderConfirmationInteractor - Found store: ${store.name}");
    }

    final cartItems = _cartService.currentItems;

    emit(state.copyWith(isLoading: false, selectedStore: store, cartItems: cartItems));
  }

  void updateDeliveryMethod(DeliveryMethod method) {
    emit(state.copyWith(deliveryMethod: method));
  }

  void selectCoupon() {
    // Navigate to coupon list and wait for result
    router?.openCouponList(this);
  }

  void updatePaymentMethod(String method) {
    emit(state.copyWith(paymentMethod: method));
  }

  void updateNote(String note) {
    emit(state.copyWith(note: note));
  }
}

/// Private Mixin xử lý riêng các callback từ CouponList
///

// region Payment method
mixin _OrderConfirmationPaymentMixin on CubitInteractor<OrderConfirmationRoutable, OrderConfirmationState> {
  Future<void> processPayment() async {
    if (state.status == OrderConfirmationStatus.processing) return;

    // Guard check (không kèm UI)
    if (!UserManager().isLogin) return;

    emit(state.copyWith(status: OrderConfirmationStatus.processing, processingMessage: 'Đang xử lý thanh toán ...'));

    // Giả lập delay 3s
    await Future.delayed(const Duration(seconds: 3));

    // Empty cart upon success
    final cartService = locator<CartService>();
    await cartService.clearCart();

    // Mock thành công (hoặc thất bại tùy logic)
    emit(
      state.copyWith(
        status: OrderConfirmationStatus.success,
        orderNumber: '#CB${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      ),
    );
  }

  void retryPayment() {
    emit(state.copyWith(status: OrderConfirmationStatus.confirming));
  }
}
// endregion

// region UserAuthFlowListener implementation
mixin _OrderConfirmationLoginMixin on CubitInteractor<OrderConfirmationRoutable, OrderConfirmationState>
    implements UserAuthFlowListener {
  @override
  void onAuthFlowSuccess(UserSession userData) {
    // Thực hiện emit reload lai trang thai trang
    emit(state.copyWith());

    debugPrint("Auth Flow Success - Reload Profile Data");
    // Chỉ cần bắn event. Listener trong onDidBecomeActive sẽ tự động gọi checkLoginStatus()
    // Điều này tránh việc checkLoginStatus() bị chạy 2 lần.
    locator<DbEventBus>().fire(UserLoginSuccessEvent(userData));
  }

  @override
  void onAuthFlowCancelled(DbError error) {
    // Do nothing or show message
  }
}
// endregion

// region Listener method
mixin _CouponListListenerMixin on CubitInteractor<OrderConfirmationRoutable, OrderConfirmationState>
    implements CouponListListener {
  @override
  void onCouponSelected(CouponModel coupon) {
    // Logic tính toán discount
    double discount = coupon.discountValue;
    if (coupon.discountType == "%") {
      discount = state.subtotal * (discount / 100);
    }

    emit(state.copyWith(selectedCoupon: coupon.title, couponDiscount: discount));
  }

  @override
  void onNoCouponSelected() {
    // emit(state.copyWith(
    //   selectedCoupon: null,
    //   couponDiscount: 0,
    // ));
  }
}

// endregion
