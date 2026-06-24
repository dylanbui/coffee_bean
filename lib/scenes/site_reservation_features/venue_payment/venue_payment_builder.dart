import 'package:coffee_bean/scenes/my_profile_features/coupon_list/coupon_list_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/coupon_list/interactor/coupon_list_interactor.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/venue_payment_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/venue_payment_interactor.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/venue_payment_page.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_flow.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

abstract class VenuePaymentRoutable implements DbNoteRoutable {
  void openCouponList(CouponListListener listener);
  void doLoginFlow(UserAuthFlowListener listener);
}

class VenuePaymentRouter extends DbNoteRouter implements VenuePaymentRoutable {
  @override
  void openCouponList(CouponListListener listener) {
    final builder = CouponListBuilder(listener: listener);
    navigator.push(builder.build().viewController);
  }

  @override
  void doLoginFlow(UserAuthFlowListener listener) {
    UserAuthFlow(startStep: AuthStartStep.login).start(this, listener);
  }
}

class VenuePaymentBuilder extends DbNoteBuilder<VenuePaymentRouter> {

  final VenuePaymentParams params;

  VenuePaymentBuilder(this.params);

  @override
  VenuePaymentRouter build() {
    final router = VenuePaymentRouter();
    final interactor = VenuePaymentInteractor(
      params: params,
      router: router,
    );

    router.attach(interactor, VenuePaymentPage(interactor: interactor));
    return router;
  }
}
