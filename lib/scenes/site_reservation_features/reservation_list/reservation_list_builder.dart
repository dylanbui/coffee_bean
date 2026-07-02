import 'package:coffee_bean/scenes/site_reservation_features/reservation_list/interactor/reservation_list_interactor.dart';
import 'package:coffee_bean/scenes/site_reservation_features/reservation_list/interactor/reservation_list_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/data/model/response/hub/venue_info.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/venue_detail_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

abstract class ReservationListRoutable implements DbNoteRoutable {
  void openVenueDetail(VenueInfo venue);
}

// ROUTER
class ReservationListRouter extends DbNoteRouter implements ReservationListRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // Handle navigation to other scenes
  }

  @override
  void openVenueDetail(VenueInfo venue) {
    final builder = VenueDetailBuilder();
    final router = builder.build();
    push(router.viewController);
  }
}

// BUILDER
class ReservationListBuilder extends DbNoteBuilder<ReservationListRouter> {
  @override
  ReservationListRouter build() {
    final router = ReservationListRouter();
    final interactor = ReservationListInteractor(router);
    final page = ReservationListPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
