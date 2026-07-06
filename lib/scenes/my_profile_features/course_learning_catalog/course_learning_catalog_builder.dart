import 'package:coffee_bean/scenes/my_profile_features/course_learning_catalog/interactor/course_learning_catalog_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_catalog/interactor/course_learning_catalog_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/course_features/instructor_detail/instructor_detail_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

abstract class CourseLearningCatalogRoutable implements DbNoteRoutable {
  void gotoLessonDetail(int lessonId);
  void gotoInstructorDetail(int instructorId);
}

class CourseLearningCatalogRouter extends DbNoteRouter implements CourseLearningCatalogRoutable {
  @override
  void gotoLessonDetail(int lessonId) {
    // Placeholder for course_learning_detail module
    // final builder = CourseLearningDetailBuilder(lessonId: lessonId);
    // push(builder.build().viewController);
  }

  @override
  void gotoInstructorDetail(int instructorId) {
    final builder = InstructorDetailBuilder(instructorId: instructorId);
    push(builder.build().viewController);
  }
}


class CourseLearningCatalogBuilder extends DbNoteBuilder<CourseLearningCatalogRouter> {
  final int courseId;

  CourseLearningCatalogBuilder({required this.courseId});

  @override
  CourseLearningCatalogRouter build() {
    final router = CourseLearningCatalogRouter();
    final interactor = CourseLearningCatalogInteractor(router, courseId);
    final page = CourseLearningCatalogPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
