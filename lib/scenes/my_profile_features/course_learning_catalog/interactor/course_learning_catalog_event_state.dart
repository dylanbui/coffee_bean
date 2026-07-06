import 'package:coffee_bean/data/model/response/hub/course_info_detail.dart';
import 'package:coffee_bean/data/model/response/hub/instructor_info.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_learning_catalog/interactor/mock_data.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';

class CourseLearningCatalogState extends BaseBlocState {
  final bool isLoading;
  final CourseInfoDetail? courseDetail;
  final List<LessonModel> lessons;
  final InstructorInfo? instructor;
  final String? errorMessage;

  CourseLearningCatalogState({
    this.isLoading = false,
    this.courseDetail,
    this.lessons = const [],
    this.instructor,
    this.errorMessage,
  });

  CourseLearningCatalogState copyWith({
    bool? isLoading,
    CourseInfoDetail? courseDetail,
    List<LessonModel>? lessons,
    InstructorInfo? instructor,
    String? errorMessage,
  }) {
    return CourseLearningCatalogState(
      isLoading: isLoading ?? this.isLoading,
      courseDetail: courseDetail ?? this.courseDetail,
      lessons: lessons ?? this.lessons,
      instructor: instructor ?? this.instructor,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, courseDetail, lessons, instructor, errorMessage];
}
