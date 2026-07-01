import 'package:coffee_bean/data/model/response/promotion/point_breakdown.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';

// STATES
abstract class PointBreakdownState extends BaseBlocState {
  final List<PointBreakdownItem> items;
  final bool hasMore;
  final bool isLoadingMore;

  PointBreakdownState({
    this.items = const [],
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [items, hasMore, isLoadingMore]; // PHẢI CÓ DÒNG NÀY
}

class PointBreakdownInitial extends PointBreakdownState {
  PointBreakdownInitial() : super(items: []);
}

class PointBreakdownStartLoading extends PointBreakdownState {
  PointBreakdownStartLoading() : super(items: []);
}

// class PointBreakdownLoading extends PointBreakdownState {
//   PointBreakdownLoading({required super.items, super.hasMore});
// }

class PointBreakdownRefreshing extends PointBreakdownState {
  PointBreakdownRefreshing({required super.items, required super.hasMore});
}

class PointBreakdownDone extends PointBreakdownState {
  PointBreakdownDone({
    required super.items,
    required super.hasMore,
    super.isLoadingMore = false,
  });
}
