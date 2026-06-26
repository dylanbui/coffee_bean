import 'dart:async';
import 'package:coffee_bean/data/repository/course_repository.dart';
import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:coffee_bean/scenes/course_features/course_detail/course_checkout_item.dart';
import 'package:coffee_bean/scenes/course_features/course_detail/course_detail_builder.dart';
import 'package:coffee_bean/scenes/course_features/course_detail/interactor/course_detail_event_state.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/utils/locator.dart';
import 'package:db_core/utils/toast.dart';

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
    
    final course = await _courseRepository.getCourseById(courseId);
    
    if (course != null) {
      emit(state.copyWith(
        isLoading: false,
        courseTitle: course.name,
        courseDescription: course.description ?? "",
        totalAmount: course.price,
        images: course.images?.map((e) => e.url ?? "").toList() ?? [],
        // --- MOCK DATA (Sẽ cập nhật khi DB có các field này) ---
        instructorName: course.instructor ?? "TYLER BALLMER",
        // instructorBio & instructorAvatar sử dụng giá trị mặc định trong state
        // -------------------------------------------------------
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
    final checkoutItem = CourseCheckoutItem(
      courseId: courseId,
      courseTitle: state.courseTitle,
      instructorName: state.instructorName,
      courseImageUrl: state.images.isNotEmpty ? state.images.first : null,
      coursePrice: state.totalAmount,
    );
    router?.openCheckout(checkoutItem);
  }

  void onInstructorDetailTap() {
    DbToast.show("Xem chi tiết giảng viên");
  }

  @override
  void onNavigateToAllComments(int productId, int type) {
    router?.gotoCommentList(productId, type);
  }
}
