import 'package:coffee_bean/data/model/response/reward_point_history.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';

// STATES
abstract class RewardPointHistoryState extends BaseBlocState {
  final List<RewardPointHistoryItem> items;
  final bool hasMore;
  final bool isLoadingMore;

  RewardPointHistoryState({
    this.items = const [],
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [items, hasMore, isLoadingMore]; // PHẢI CÓ DÒNG NÀY
}

class RewardPointHistoryInitial extends RewardPointHistoryState {
  RewardPointHistoryInitial() : super(items: []);
}

class RewardPointHistoryLoading extends RewardPointHistoryState {
  RewardPointHistoryLoading({required super.items, super.hasMore});
}

class RewardPointHistoryDone extends RewardPointHistoryState {
  RewardPointHistoryDone({
    required super.items,
    required super.hasMore,
    super.isLoadingMore = false,
  });
}