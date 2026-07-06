import 'package:coffee_bean/data/model/response/hub/course_info.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/scenes/course_features/instructor_profile/models/instructor_profile_model.dart';
import 'package:coffee_bean/scenes/course_features/instructor_profile/models/instructor_post_model.dart';

enum InstructorTab { posts, courses }

class InstructorProfileState extends BaseBlocState {
  final bool isLoading;
  final InstructorProfileModel? instructor;
  final List<InstructorPostModel> posts;
  final List<CourseInfo> courses;
  final InstructorTab currentTab;
  final String? errorMessage;
  final String? successMessage;

  InstructorProfileState({
    this.isLoading = false,
    this.instructor,
    this.posts = const [],
    this.courses = const [],
    this.currentTab = InstructorTab.posts,
    this.errorMessage,
    this.successMessage,
  });

  @override
  List<Object?> get props => [
        isLoading,
        instructor,
        posts,
        courses,
        currentTab,
        errorMessage,
        successMessage,
      ];

  InstructorProfileState copyWith({
    bool? isLoading,
    InstructorProfileModel? instructor,
    List<InstructorPostModel>? posts,
    List<CourseInfo>? courses,
    InstructorTab? currentTab,
    String? errorMessage,
    String? successMessage,
  }) {
    return InstructorProfileState(
      isLoading: isLoading ?? this.isLoading,
      instructor: instructor ?? this.instructor,
      posts: posts ?? this.posts,
      courses: courses ?? this.courses,
      currentTab: currentTab ?? this.currentTab,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
