import 'package:coffee_bean/data/model/response/promotion/point_breakdown.dart';
import 'package:db_core/db_core.dart';

class InvitationRewardDetailState extends BaseBlocState {
  final bool isLoading;
  final bool isLoadMore;
  final String? errorMessage;
  final List<PointBreakdownItem> items;
  final int pageNo;
  final bool hasMore;

  InvitationRewardDetailState({
    this.isLoading = false,
    this.isLoadMore = false,
    this.errorMessage,
    this.items = const [],
    this.pageNo = 1,
    this.hasMore = true,
  });

  InvitationRewardDetailState copyWith({
    bool? isLoading,
    bool? isLoadMore,
    String? errorMessage,
    List<PointBreakdownItem>? items,
    int? pageNo,
    bool? hasMore,
  }) {
    return InvitationRewardDetailState(
      isLoading: isLoading ?? this.isLoading,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      errorMessage: errorMessage,
      items: items ?? this.items,
      pageNo: pageNo ?? this.pageNo,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [isLoading, isLoadMore, errorMessage, items, pageNo, hasMore];
}
