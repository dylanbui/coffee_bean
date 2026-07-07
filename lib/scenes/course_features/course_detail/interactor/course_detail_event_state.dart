import 'package:coffee_bean/data/model/response/hub/course_info_detail.dart';
import 'package:coffee_bean/data/model/response/hub/instructor_info.dart';
import 'package:equatable/equatable.dart';

class CourseDetailState extends Equatable {
  final bool isLoading;
  final bool isLiked;
  final CourseInfoDetail? courseDetail;
  final InstructorInfo? instructor;

  const CourseDetailState({
    this.isLoading = false,
    this.isLiked = false,
    this.courseDetail,
    this.instructor,
  });

  CourseDetailState copyWith({
    bool? isLoading,
    bool? isLiked,
    CourseInfoDetail? courseDetail,
    InstructorInfo? instructor,
  }) {
    return CourseDetailState(
      isLoading: isLoading ?? this.isLoading,
      isLiked: isLiked ?? this.isLiked,
      courseDetail: courseDetail ?? this.courseDetail,
      instructor: instructor ?? this.instructor,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isLiked,
        courseDetail,
        instructor,
      ];
}
