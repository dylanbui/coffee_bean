import 'dart:async';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/model/response/hub/instructor_info.dart';
import 'package:coffee_bean/data/repository/course_repository.dart';
import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:coffee_bean/scenes/course_features/course_detail/course_checkout_item.dart';
import 'package:coffee_bean/scenes/course_features/course_detail/course_detail_builder.dart';
import 'package:coffee_bean/scenes/course_features/course_detail/interactor/course_detail_event_state.dart';
import 'package:db_core/db_core.dart';

class CourseDetailInteractor extends CubitInteractor<CourseDetailRoutable, CourseDetailState>
    implements CommentListSmallListener {
  final CourseRepository _courseRepository = locator<CourseRepository>();
  final int courseId;
  final commentController = CommentListSmallController();

  CourseDetailInteractor(CourseDetailRoutable router, this.courseId)
      : super(const CourseDetailState(), router: router) {
    commentController.listener = this;
  }

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadCourseDetail();
  }

  Future<void> _loadCourseDetail() async {
    emit(state.copyWith(isLoading: true));
    
    final result = await _courseRepository.getCourseDetailById(courseId);
    
    if (result case DbSuccess(data: final course)) {
      InstructorInfo? instructor;

      if (course.instructorId != null) {
        final instructorResult = await _courseRepository.getInstructorById(course.instructorId!);
        if (instructorResult case DbSuccess(data: final instructorData)) {
          instructor = instructorData;
        }
      }

      emit(state.copyWith(
        isLoading: false,
        courseDetail: course,
        instructor: instructor,
      ));
    } else {
      emit(state.copyWith(isLoading: false));
      DbToast.show("Không tìm thấy thông tin khóa học");
    }
  }

  void onLikeTap() {
    // Optimistic UI update
    emit(state.copyWith(isLiked: !state.isLiked));

    // Logic gọi API thực tế đặt tại đây. 
    // Debounce/Throttle đã được xử lý bởi TapEffect ở tầng UI.
    DbToast.show(state.isLiked ? "Đã thích khóa học" : "Đã bỏ thích khóa học");
  }

  void onBuyTap() {
    final user = UserManager().userInfo;
    final course = state.courseDetail;
    final instructor = state.instructor;
    
    if (course == null) return;

    final checkoutItem = CourseCheckoutItem(
      courseId: courseId,
      courseTitle: course.courseName,
      instructorName: instructor?.instructorName ?? "Đang cập nhật",
      courseImageUrl: course.courseCover.isNotEmpty ? course.courseCover.first : null,
      coursePrice: course.coursePrice ?? 0,
      initialNickname: user?.nickname ?? "",
      initialPhone: user?.mobile ?? "",
    );
    router?.openCheckout(checkoutItem);
  }

  void onInstructorDetailTap() {
    final instructorId = state.courseDetail?.instructorId;
    if (instructorId != null) {
      router?.gotoInstructorDetail(instructorId);
    }
  }

  @override
  void onNavigateToAllComments(int productId, int type) {
    router?.gotoCommentList(productId, type);
  }
}
