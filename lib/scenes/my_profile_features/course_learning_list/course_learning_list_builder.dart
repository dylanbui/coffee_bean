import 'package:coffee_bean/scenes/my_profile_features/course_learning_list/interactor/course_learning_list_interactor.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_list/interactor/course_learning_list_page.dart';
import 'package:db_core/db_core.dart';

abstract class CourseLearningListRoutable implements DbNoteRoutable {}

class CourseLearningListRouter extends DbNoteRouter implements CourseLearningListRoutable {}

class CourseLearningListBuilder extends DbNoteBuilder<CourseLearningListRouter> {
  @override
  CourseLearningListRouter build() {
    final router = CourseLearningListRouter();
    final interactor = CourseLearningListInteractor(router);
    final page = CourseLearningListPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
