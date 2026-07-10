import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/models/mock_data.dart' as catalog_mock;
import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/models/course_order_model.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_detail/models/course_order_detail_model.dart';

final List<CourseOrderDetailModel> mockCourseOrderDetails = catalog_mock.mockCourseOrders.map((order) {
  // Logic bổ sung thêm dữ liệu chi tiết dựa trên trạng thái
  return CourseOrderDetailModel(
    id: int.parse(order.id),
    title: order.title,
    description: order.description,
    imageUrl: order.imageUrl,
    price: order.price,
    discountPrice: order.discountPrice,
    status: order.status,
    createdAt: order.createdAt,
    expiredAt: order.expiredAt,
    orderCode: "SC2024${order.id.padLeft(8, '0')}",
    pointDiscount: (order.id == "1" || order.id == "5") ? 11200 : 0,
    paymentAt: order.status != CourseOrderStatus.pending ? order.createdAt.add(const Duration(minutes: 5)) : null,
    completedAt: order.status == CourseOrderStatus.completed ? order.createdAt.add(const Duration(hours: 1)) : null,
    cancelledAt: order.status == CourseOrderStatus.cancelled ? order.createdAt.add(const Duration(minutes: 30)) : null,
    cancelReason: order.status == CourseOrderStatus.cancelled ? "Hết hạn thanh toán" : null,
    isRated: order.id == "4",
  );
}).toList();
