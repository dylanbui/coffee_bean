import 'package:coffee_bean/scenes/reservation_list/interactor/reservation_list_interactor.dart';
import 'package:coffee_bean/scenes/reservation_list/interactor/reservation_list_page.dart';
import 'package:coffee_bean/scenes/reservation_list/reservation_list_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class ReservationListBuilder {
//   static Widget build() {
//     return BlocProvider(
//       create: (context) {
//         final router = ReservationListRouter(context);
//         return ReservationListInteractor(router);
//       },
//       child: const ReservationListPage(),
//     );
//   }
// }

import 'package:db_core/architecture_ribs/note_builder.dart';

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
