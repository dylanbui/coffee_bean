import 'package:coffee_bean/scenes/course_features/instructor_profile/instructor_profile_builder.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/shared/service/system_notify/system_notify_event.dart';
import 'package:coffee_bean/scenes/course_features/instructor_profile/interactor/instructor_profile_event_state.dart';
import 'package:coffee_bean/scenes/course_features/instructor_profile/interactor/mock_data.dart';

class InstructorProfileInteractor extends CubitInteractor<InstructorProfileRoutable, InstructorProfileState> {
  final int instructorId;

  InstructorProfileInteractor(InstructorProfileRoutable router, this.instructorId) 
      : super(InstructorProfileState(isLoading: true), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _fetchData();
  }

  Future<void> _fetchData() async {
    emit(state.copyWith(isLoading: true));
    
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    emit(state.copyWith(
      isLoading: false,
      instructor: InstructorMockData.mockInstructor,
      posts: InstructorMockData.mockPosts,
      courses: InstructorMockData.mockCourses,
    ));
  }

  void onTabChanged(InstructorTab tab) {
    emit(state.copyWith(currentTab: tab));
  }

  void onFollowTap() {
    final isFollowed = state.instructor?.isFollowed ?? false;
    final message = isFollowed ? "Đã bỏ theo dõi chuyên gia" : "Đã theo dõi chuyên gia thành công";
    
    // For mock, just toggle isFollowed
    if (state.instructor != null) {
      locator<DbEventBus>().fire(SystemSuccessNotifyEvent(message));
    }
  }

  void onPostTap(int postId) {
    locator<DbEventBus>().fire(SystemInfoNotifyEvent("Xem bài viết: $postId"));
  }

  void onCourseTap(int courseId) {
    locator<DbEventBus>().fire(SystemInfoNotifyEvent("Xem khóa học: $courseId"));
  }
}
