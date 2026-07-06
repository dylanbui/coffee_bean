import 'package:coffee_bean/scenes/my_profile_features/course_learning_detail/course_learning_detail_router.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_detail/interactor/course_learning_detail_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_detail/interactor/course_learning_detail_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';

import 'package:db_core/architecture_ribs/note_router.dart';

abstract class CourseLearningDetailRoutable implements DbNoteRoutable {}

class CourseLearningDetailRouter extends DbNoteRouter implements CourseLearningDetailRoutable {}


class CourseLearningDetailBuilder extends DbNoteBuilder<CourseLearningDetailRouter> {
  final int lessonId;

  CourseLearningDetailBuilder({required this.lessonId});

  @override
  CourseLearningDetailRouter build() {
    final router = CourseLearningDetailRouter();
    final interactor = CourseLearningDetailInteractor(router, lessonId);
    final page = CourseLearningDetailPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
