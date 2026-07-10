import 'package:equatable/equatable.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/models/course_order_model.dart';

class CourseOrderDetailModel extends Equatable {
  // Bổ sung các field từ CourseOrderModel (vì không muốn thay đổi Catalog)
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final double discountPrice;
  final CourseOrderStatus status;
  final DateTime createdAt;
  final DateTime? expiredAt;

  // Các field mới chỉ dùng cho Detail
  final String orderCode;
  final double pointDiscount;
  final DateTime? paymentAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancelReason;
  final bool isRated;

  const CourseOrderDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.discountPrice,
    required this.status,
    required this.createdAt,
    this.expiredAt,
    required this.orderCode,
    this.pointDiscount = 0,
    this.paymentAt,
    this.completedAt,
    this.cancelledAt,
    this.cancelReason,
    this.isRated = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        price,
        discountPrice,
        status,
        createdAt,
        expiredAt,
        orderCode,
        pointDiscount,
        paymentAt,
        completedAt,
        cancelledAt,
        cancelReason,
        isRated,
      ];
}
