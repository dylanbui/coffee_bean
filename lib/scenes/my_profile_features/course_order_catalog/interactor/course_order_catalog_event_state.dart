import 'package:coffee_bean/scenes/my_profile_features/course_order_catalog/models/course_order_model.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';

class CourseOrderCatalogState extends BaseBlocState {
  final bool isLoading;
  final List<CourseOrderModel> orders;
  final int activeTabIndex;

  CourseOrderCatalogState({
    this.isLoading = false,
    this.orders = const [],
    this.activeTabIndex = 0,
  });

  CourseOrderCatalogState copyWith({
    bool? isLoading,
    List<CourseOrderModel>? orders,
    int? activeTabIndex,
  }) {
    return CourseOrderCatalogState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
    );
  }

  @override
  List<Object?> get props => [isLoading, orders, activeTabIndex];
}
