import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:coffee_bean/data/repository/payment_domain_repository.dart';
import 'package:coffee_bean/scenes/my_profile_features/coupon_list/interactor/coupon_list_interactor.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/venue_payment_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/venue_payment_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_flow.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_helper.dart';
import 'package:db_core/db_core.dart';

class VenuePaymentInteractor extends CubitInteractor<VenuePaymentRoutable, VenuePaymentState>
    with _VenuePaymentPaymentMixin, _VenuePaymentLoginMixin, _VenueCouponListListenerMixin
    implements CouponListListener, UserAuthFlowListener {
  final PaymentDomainRepository paymentRepo = locator<PaymentDomainRepository>();

  VenuePaymentInteractor({
    required VenuePaymentParams params,
    VenuePaymentRoutable? router,
  }) : super(
          VenuePaymentState(params: params),
          router: router,
        );

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    
    // Dữ liệu params đã có sẵn từ constructor, tắt loading ngay
    emit(state.copyWith(
      uiStatus: state.uiStatus.copyWith(isLoading: false),
    ));

    // Lắng nghe sự kiện login thành công để reload UI
    collect(
      locator<DbEventBus>().on<UserLoginSuccessEvent>().listen((event) {
        emit(state.copyWith());
      }),
    );
  }

  void updatePaymentMethod(String methodKey) {
    emit(state.copyWith(preferences: state.preferences.copyWith(paymentMethodKey: methodKey)));
  }

  void selectCoupon() {
    router?.openCouponList(this);
  }

  void doLogin() {
    router?.doLoginFlow(this);
  }
}

// region Payment mixin
mixin _VenuePaymentPaymentMixin on CubitInteractor<VenuePaymentRoutable, VenuePaymentState> {
  Future<void> processPayment() async {
    if (state.status == VenuePaymentStatus.processing) return;
    if (!UserManager().isLogin) return;

    emit(state.copyWith(
      status: VenuePaymentStatus.processing,
      uiStatus: state.uiStatus.copyWith(processingMessage: 'PAYMENT_PROCESSING'),
    ));

    // Giả lập call API thanh toán
    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(
      status: VenuePaymentStatus.success,
    ));
  }

  void retryPayment() {
    emit(state.copyWith(status: VenuePaymentStatus.confirming));
  }
}
// endregion

// region Auth mixin
mixin _VenuePaymentLoginMixin on CubitInteractor<VenuePaymentRoutable, VenuePaymentState>
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

// region Coupon mixin
mixin _VenueCouponListListenerMixin on CubitInteractor<VenuePaymentRoutable, VenuePaymentState>
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
