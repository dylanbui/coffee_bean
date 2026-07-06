import 'dart:async';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_detail/course_learning_detail_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_detail/interactor/course_learning_detail_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_detail/interactor/mock_data.dart';
import 'package:db_core/db_core.dart';

class CourseLearningDetailInteractor extends CubitInteractor<CourseLearningDetailRoutable, CourseLearningDetailState> {
  final int lessonId;

  CourseLearningDetailInteractor(CourseLearningDetailRoutable router, this.lessonId)
      : super(CourseLearningDetailState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadLessonDetail();
  }

  Future<void> _loadLessonDetail() async {
    emit(state.copyWith(isLoading: true));
    
    // Giả lập delay gọi API
    await Future.delayed(const Duration(milliseconds: 800));
    
    final lesson = CourseLearningDetailMockData.getMockLesson(lessonId);
    
    emit(state.copyWith(
      isLoading: false,
      lesson: lesson,
    ));
  }
}
