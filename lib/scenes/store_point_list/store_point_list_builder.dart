import 'package:db_core/architecture_ribs/note_builder.dart';
import 'interactor/store_point_list_interactor.dart';
import 'interactor/store_point_list_page.dart';
import 'store_point_list_router.dart';

class StorePointListBuilder extends DbNoteBuilder<StorePointListRouter> {
  @override
  StorePointListRouter build() {
    final router = StorePointListRouter();
    final interactor = StorePointListInteractor(router);
    final page = StorePointListPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
