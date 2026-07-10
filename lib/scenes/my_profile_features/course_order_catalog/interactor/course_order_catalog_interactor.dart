import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/course_order_catalog_builder.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/course_order_catalog_router.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/interactor/course_order_catalog_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/models/course_order_model.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/models/mock_data.dart';
import 'package:db_core/db_core.dart';

class CourseOrderCatalogInteractor extends CubitInteractor<CourseOrderCatalogRoutable, CourseOrderCatalogState> {
  CourseOrderCatalogInteractor(CourseOrderCatalogRoutable router) : super(CourseOrderCatalogState(), router: router);

  @override
  void onDidBecomeActive() {
    loadOrders();
  }

  void onTabChanged(int index) {
    if (state.activeTabIndex == index) return;
    emit(state.copyWith(activeTabIndex: index));
    loadOrders();
  }

  Future<void> loadOrders() async {
    emit(state.copyWith(isLoading: true));
    
    // Giả lập delay API
    await Future.delayed(const Duration(milliseconds: 500));

    List<CourseOrderModel> filteredOrders;
    switch (state.activeTabIndex) {
      case 1: // Chờ thanh toán
        filteredOrders = mockCourseOrders.where((o) => o.status == CourseOrderStatus.pending).toList();
        break;
      case 2: // Đã hoàn thành
        filteredOrders = mockCourseOrders.where((o) => o.status == CourseOrderStatus.completed).toList();
        break;
      case 3: // Đã hủy
        filteredOrders = mockCourseOrders.where((o) => o.status == CourseOrderStatus.cancelled).toList();
        break;
      default: // Tất cả
        filteredOrders = List.from(mockCourseOrders);
        break;
    }

    emit(state.copyWith(isLoading: false, orders: filteredOrders));
  }

  void onOrderDetail(CourseOrderModel order) {
    router?.goToOrderDetail(order.id);
  }

  // --- Actions ---

  void onPayOrder(CourseOrderModel order) {
    // Logic thanh toán
    print("Thanh toán đơn hàng: ${order.id}");
  }

  void onReviewOrder(CourseOrderModel order) {
    // Logic đánh giá
    print("Đánh giá đơn hàng: ${order.id}");
  }

  void onStartLearning(CourseOrderModel order) {
    // Logic bắt đầu học
    print("Bắt đầu học: ${order.title}");
  }

  void onOrderExpired(CourseOrderModel order) {
    // Logic khi đơn hàng hết hạn
    print("Đơn hàng ${order.id} đã hết hạn");
    // Trong thực tế sẽ gọi API cập nhật trạng thái, ở đây ta load lại data
    loadOrders();
  }
}
