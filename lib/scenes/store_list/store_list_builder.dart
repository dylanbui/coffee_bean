import 'package:db_core/architecture_ribs/note_builder.dart';
import 'interactor/store_list_interactor.dart';
import 'interactor/store_list_page.dart';
import 'store_list_router.dart';

class StoreListBuilder extends DbNoteBuilder<StoreListRouter> {
  @override
  StoreListRouter build() {
    final router = StoreListRouter();
    final interactor = StoreListInteractor(router);
    final page = StoreListPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
