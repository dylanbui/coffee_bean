import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/interactor/course_order_catalog_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/interactor/course_order_catalog_page.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_detail/course_order_detail_builder.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

abstract class CourseOrderCatalogRoutable implements DbNoteRoutable {
  void goToOrderDetail(String orderId);
}

class CourseOrderCatalogRouter extends DbNoteRouter implements CourseOrderCatalogRoutable {
  @override
  void goToOrderDetail(String orderId) {
    final builder = CourseOrderDetailBuilder(int.parse(orderId));
    push(builder.build().viewController);
  }
}

class CourseOrderCatalogBuilder extends DbNoteBuilder<CourseOrderCatalogRouter> {
  @override
  CourseOrderCatalogRouter build() {
    final router = CourseOrderCatalogRouter();
    final interactor = CourseOrderCatalogInteractor(router);
    final page = CourseOrderCatalogPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
