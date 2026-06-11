import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/venue_detail_builder.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

abstract class ReservationListRoutable implements DbNoteRoutable {
  void openVenueDetail(TblReservation venue);
}

class ReservationListRouter extends DbNoteRouter implements ReservationListRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // Handle navigation to other scenes
  }

  @override
  void openVenueDetail(TblReservation venue) {
    final builder = VenueDetailBuilder();
    final router = builder.build();
    navigator.push(router.viewController);
  }
}
