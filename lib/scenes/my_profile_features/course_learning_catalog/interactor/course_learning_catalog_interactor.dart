import 'dart:async';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_catalog/course_learning_catalog_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_catalog/interactor/course_learning_catalog_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_catalog/interactor/mock_data.dart';
import 'package:db_core/db_core.dart';

class CourseLearningCatalogInteractor extends CubitInteractor<CourseLearningCatalogRoutable, CourseLearningCatalogState> {
  final int courseId;

  CourseLearningCatalogInteractor(CourseLearningCatalogRoutable router, this.courseId)
      : super(CourseLearningCatalogState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadData();
  }

  Future<void> _loadData() async {
    emit(state.copyWith(isLoading: true));
    
    // Giả lập delay gọi API
    await Future.delayed(const Duration(milliseconds: 800));
    
    final detail = CourseCatalogMockData.getMockCourseDetail(courseId);
    final lessons = CourseCatalogMockData.getMockLessons();
    final instructor = CourseCatalogMockData.getMockInstructor(detail.instructorId ?? 0);
    
    emit(state.copyWith(
      isLoading: false,
      courseDetail: detail,
      lessons: lessons,
      instructor: instructor,
    ));
  }

  void onLessonTap(LessonModel lesson) {
    router?.gotoLessonDetail(lesson.id);
  }

  void onInstructorDetailTap() {
    final instructorId = state.courseDetail?.instructorId;
    if (instructorId != null) {
      router?.gotoInstructorDetail(instructorId);
    }
  }
}
