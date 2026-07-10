import 'package:equatable/equatable.dart';

enum CourseOrderStatus {
  pending,    // Chờ thanh toán
  completed,  // Đã hoàn thành
  cancelled   // Đã hủy
}

class CourseOrderModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final double discountPrice;
  final CourseOrderStatus status;
  final DateTime createdAt;
  final DateTime? expiredAt;

  const CourseOrderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.discountPrice,
    required this.status,
    required this.createdAt,
    this.expiredAt,
  });

  @override
  List<Object?> get props => [id, title, description, imageUrl, price, discountPrice, status, createdAt, expiredAt];
}
