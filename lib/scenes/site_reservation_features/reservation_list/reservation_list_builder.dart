import 'package:coffee_bean/scenes/site_reservation_features/reservation_list/interactor/reservation_list_interactor.dart';
import 'package:coffee_bean/scenes/site_reservation_features/reservation_list/interactor/reservation_list_page.dart';
import 'package:coffee_bean/scenes/site_reservation_features/reservation_list/reservation_list_router.dart';
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
