import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/point_features/my_point_list/interactor/my_point_list_interactor.dart';
import 'package:coffee_bean/scenes/point_features/my_point_list/interactor/my_point_list_page.dart';
import 'package:coffee_bean/scenes/point_features/my_point_list/my_point_list_router.dart';

// Document: lanhuapp.com
// https://lanhuapp.com/web/#/item/project/product?tid=807b9e8b-26ba-4d2b-8f9a-2d3d514ed489&pid=cbb3e997-8bff-4ea4-9e73-fe908fad8c3b&versionId=6426ceef-c68b-4334-995b-31b86f19f9f3&docId=e0bd6d23-a905-41ac-b61c-72264f0cad42&docType=axure&pageId=0ca0948f7c7148e6bbb91cfab6ffbaf9&image_id=e0bd6d23-a905-41ac-b61c-72264f0cad42&parentId=902087fd7fe84d75ba2974eeac455e66&share_type=quickShare
class MyPointListBuilder extends DbNoteBuilder<MyPointListRouter> {
  @override
  MyPointListRouter build() {
    final router = MyPointListRouter();
    final interactor = MyPointListInteractor(router);
    final page = MyPointListPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
