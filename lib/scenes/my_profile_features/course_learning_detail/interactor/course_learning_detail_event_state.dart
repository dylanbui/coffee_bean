import 'package:coffee_bean/scenes/my_profile_features/course_learning_detail/interactor/mock_data.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';


class CourseLearningDetailState extends BaseBlocState {
  final bool isLoading;
  final CourseLessonModel? lesson;
  final String? errorMessage;

  CourseLearningDetailState({
    this.isLoading = false,
    this.lesson,
    this.errorMessage,
  });

  CourseLearningDetailState copyWith({
    bool? isLoading,
    CourseLessonModel? lesson,
    String? errorMessage,
  }) {
    return CourseLearningDetailState(
      isLoading: isLoading ?? this.isLoading,
      lesson: lesson ?? this.lesson,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, lesson, errorMessage];
}
