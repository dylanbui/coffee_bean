import 'package:coffee_bean/data/model/response/user/invite_models.dart';
import 'package:db_core/db_core.dart';

class InvitationRankingState extends BaseBlocState {
  final bool isLoading;
  final String timeRange; // ALL, DAILY, WEEKLY, MONTHLY
  final List<InviteRanking> rankingList;
  final DbFailure? failure;

  InvitationRankingState({
    this.isLoading = false,
    this.timeRange = 'DAILY', // Default according to design (Daily tab selected)
    this.rankingList = const [],
    this.failure,
  });

  InvitationRankingState copyWith({
    bool? isLoading,
    String? timeRange,
    List<InviteRanking>? rankingList,
    DbFailure? failure,
  }) {
    return InvitationRankingState(
      isLoading: isLoading ?? this.isLoading,
      timeRange: timeRange ?? this.timeRange,
      rankingList: rankingList ?? this.rankingList,
      failure: failure, // We might want to clear failure by passing null
    );
  }

  @override
  List<Object?> get props => [isLoading, timeRange, rankingList, failure];
}
