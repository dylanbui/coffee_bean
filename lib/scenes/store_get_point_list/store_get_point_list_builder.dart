import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/store_get_point_list/interactor/store_get_point_list_interactor.dart';
import 'package:coffee_bean/scenes/store_get_point_list/interactor/store_get_point_list_page.dart';
import 'package:coffee_bean/scenes/store_get_point_list/store_get_point_list_router.dart';

class StoreGetPointListBuilder extends DbNoteBuilder<StoreGetPointListRouter> {
  @override
  StoreGetPointListRouter build() {
    final router = StoreGetPointListRouter();
    final interactor = StoreGetPointListInteractor(router);
    final page = StoreGetPointListPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
