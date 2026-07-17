import 'package:coffee_bean/scenes/course_features/create_course_application/interactor/create_course_application_interactor.dart';
import 'package:coffee_bean/scenes/course_features/create_course_application/interactor/create_course_application_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

// ROUTABLE INTERFACE
abstract class CreateCourseApplicationRoutable implements DbNoteRoutable {
  // Định nghĩa các phương thức điều hướng nếu cần
}

// ROUTER
class CreateCourseApplicationRouter extends DbNoteRouter implements CreateCourseApplicationRoutable {
  // Triển khai logic điều hướng
}

// BUILDER
class CreateCourseApplicationBuilder extends DbNoteBuilder<CreateCourseApplicationRouter> {
  CreateCourseApplicationBuilder();

  @override
  CreateCourseApplicationRouter build() {
    final router = CreateCourseApplicationRouter();
    final interactor = CreateCourseApplicationInteractor(router);
    final page = CreateCourseApplicationPage(interactor: interactor);
    
    // Kết nối các thành phần RIBs
    router.attach(interactor, page);
    
    return router;
  }
}
