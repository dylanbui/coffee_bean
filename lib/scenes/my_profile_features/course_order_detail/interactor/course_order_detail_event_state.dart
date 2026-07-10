import 'package:db_core/db_core.dart';
import '../models/course_order_detail_model.dart';

abstract class CourseOrderDetailEvent {}

class CourseOrderDetailState extends BaseBlocState {
  final bool isLoading;
  final String? errorMessage;
  final CourseOrderDetailModel? order;

  CourseOrderDetailState({
    this.isLoading = false,
    this.errorMessage,
    this.order,
  });

  @override
  CourseOrderDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    CourseOrderDetailModel? order,
  }) {
    return CourseOrderDetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, order];
}
