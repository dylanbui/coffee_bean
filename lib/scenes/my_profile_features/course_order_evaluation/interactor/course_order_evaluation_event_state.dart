import 'package:db_core/db_core.dart';
import 'package:coffee_bean/scenes/my_profile_features/course_order_detail/models/course_order_detail_model.dart';

abstract class CourseOrderEvaluationEvent {}

class CourseOrderEvaluationState extends BaseBlocState {
  final int orderId;
  final CourseOrderDetailModel? orderData; // Dùng cho Instant UI
  final double rating;
  final String comment;
  final List<String> images;
  final bool isSubmitting;
  final String? errorMessage;

  CourseOrderEvaluationState({
    required this.orderId,
    this.orderData,
    this.rating = 5.0,
    this.comment = "",
    this.images = const [],
    this.isSubmitting = false,
    this.errorMessage,
  });

  @override
  CourseOrderEvaluationState copyWith({
    int? orderId,
    CourseOrderDetailModel? orderData,
    double? rating,
    String? comment,
    List<String>? images,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return CourseOrderEvaluationState(
      orderId: orderId ?? this.orderId,
      orderData: orderData ?? this.orderData,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      images: images ?? this.images,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [orderId, orderData, rating, comment, images, isSubmitting, errorMessage];
}
