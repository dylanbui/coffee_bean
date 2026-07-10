import 'package:coffee_bean/data/map_provider/app_map_contract.dart';
import 'package:coffee_bean/features/app_map/app_map_builder.dart';
import 'package:coffee_bean/features/checkout_order/checkout_order_builder.dart';
import 'package:coffee_bean/features/checkout_order/checkout_order_common.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_interactor.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:db_core/data/db_location.dart';

// ROUTABLE
abstract class VenueDetailRoutable implements DbNoteRoutable {
  void openCheckoutOrder(CheckoutItemContract checkoutItem);
  void openMap(String address);
}


// -- ROUTER --
class VenueDetailRouter extends DbNoteRouter implements VenueDetailRoutable {
  VenueDetailRouter();

  @override
  void openCheckoutOrder(CheckoutItemContract checkoutItem) {
    final builder = CheckoutOrderBuilder(checkoutItem: checkoutItem);
    final nextRouter = builder.build();
    navigator.push(nextRouter.viewController);
  }

  @override
  void openMap(String address) {
    final marker = MapMarker(
      id: "tmlabs_coffee",
      location: const DbLocation(latitude: 10.796993411873403, longitude: 106.7059799422638),
      title: "TMLabs Coffee",
      address: "84a Nguyễn Cửu Vân, Gia Định, Hồ Chí Minh, Vietnam",
    );
    final builder = AppMapBuilder(marker).build();
    push(builder.viewController);
  }
}

// -- BUILDER --
class VenueDetailBuilder extends DbNoteBuilder<VenueDetailRouter> {
  final int venueId;

  VenueDetailBuilder({required this.venueId});

  @override
  VenueDetailRouter build() {
    final router = VenueDetailRouter();
    final interactor = VenueDetailInteractor(router, venueId: venueId);
    final page = VenueDetailPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
