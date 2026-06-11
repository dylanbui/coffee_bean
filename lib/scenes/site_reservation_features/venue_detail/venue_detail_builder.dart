import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_interactor.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_page.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/interactor/venue_payment_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_payment/venue_payment_builder.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:url_launcher/url_launcher.dart';

// ROUTABLE
abstract class VenueDetailRoutable implements DbNoteRoutable {
  void openVenuePayment(VenuePaymentParams params);
  void openMap(String address);
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

  @override
  void openMap(String address) async {
    final Uri googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}");
    final Uri appleMapsUrl = Uri.parse("http://maps.apple.com/?q=${Uri.encodeComponent(address)}");

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else if (await canLaunchUrl(appleMapsUrl)) {
      await launchUrl(appleMapsUrl);
    }
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
