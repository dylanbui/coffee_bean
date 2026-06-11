import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_interactor.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_page.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/venue_payment_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/venue_payment_builder.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

// ROUTABLE
abstract class VenueDetailRoutable implements DbNoteRoutable {
  void openVenuePayment(VenuePaymentParams params);
}


// -- ROUTER --
class VenueDetailRouter extends DbNoteRouter implements VenueDetailRoutable {
  VenueDetailRouter();

  @override
  void openVenuePayment(VenuePaymentParams params) {
    final builder = VenuePaymentBuilder(params);
    // Actually, following the project's DI pattern:
    final nextRouter = builder.build();
    navigator.push(nextRouter.viewController);
  }
}

// -- BUILDER --
class VenueDetailBuilder extends DbNoteBuilder<VenueDetailRouter> {
  @override
  VenueDetailRouter build() {
    final router = VenueDetailRouter();
    final interactor = VenueDetailInteractor(router);
    final page = VenueDetailPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
