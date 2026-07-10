import 'package:coffee_bean/scenes/my_profile_features/course_order_detail/course_order_detail_builder.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_detail/interactor/course_order_detail_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_detail/models/mock_data.dart';

class CourseOrderDetailInteractor extends CubitInteractor<CourseOrderDetailRoutable, CourseOrderDetailState> {
  final int orderId;

  CourseOrderDetailInteractor(CourseOrderDetailRoutable router, this.orderId) : super(CourseOrderDetailState(isLoading: true), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadOrderDetail();
  }

  void _loadOrderDetail() {
    Future.delayed(const Duration(milliseconds: 500), () {
      try {
        final order = mockCourseOrderDetails.firstWhere((element) => element.id == orderId);
        emit(state.copyWith(isLoading: false, order: order));
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: "Không tìm thấy dữ liệu đơn hàng"));
      }
    });
  }

  void cancelOrder() {
    print("Hủy đơn hàng: $orderId");
  }

  void payNow() {
    print("Thanh toán ngay: $orderId");
  }

  void goToCourse() {
    print("Học ngay khóa học: $orderId");
  }

  void rateOrder() {
    final order = state.order;
    if (order != null) {
      router?.openEvaluation(order);
    }
  }
}
