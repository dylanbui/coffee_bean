import 'package:coffee_bean/scenes/my_profile_features/course_learning_list/course_learning_list_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_list/interactor/mock_data.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_list/interactor/course_learning_list_event_state.dart';
import 'package:db_core/db_core.dart';

class CourseLearningListInteractor extends CubitInteractor<CourseLearningListRoutable, CourseLearningListState> {
  CourseLearningListInteractor(CourseLearningListRoutable router) : super(CourseLearningListState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _fetchItems();
  }

  void _fetchItems() {
    emit(state.copyWith(isLoading: true));
    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      emit(state.copyWith(
        items: CourseLearningMockData.getItems(),
        isLoading: false,
      ));
    });
  }

  void onCourseTap(CourseLearningProgressModel item) {
    router?.gotoCourseCatalog(item.course.id);
  }
}
