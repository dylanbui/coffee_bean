import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_interactor.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

// ROUTABLE
abstract class VenueDetailRoutable implements DbNoteRoutable {}

// -- ROUTER --
class VenueDetailRouter extends DbNoteRouter implements VenueDetailRoutable {
  VenueDetailRouter();
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
