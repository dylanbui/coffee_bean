import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:coffee_bean/data/model/response/user/invite_models.dart';
import 'package:db_core/db_core.dart';

class InvitationRankingState extends BaseBlocState {
  final bool isLoading;
  final String timeRange; // ALL, DAILY, WEEKLY, MONTHLY
  final List<InviteRanking> dailyRanking;
  final List<InviteRanking> weeklyRanking;
  final List<InviteRanking> monthlyRanking;
  final UserInfo? userInfo;
  final DbFailure? failure;

  InvitationRankingState({
    this.isLoading = false,
    this.timeRange = 'DAILY', // Default according to design (Daily tab selected)
    this.dailyRanking = const [],
    this.weeklyRanking = const [],
    this.monthlyRanking = const [],
    this.userInfo,
    this.failure,
  });

  List<InviteRanking> get currentRanking {
    switch (timeRange) {
      case 'WEEKLY':
        return weeklyRanking;
      case 'MONTHLY':
        return monthlyRanking;
      case 'DAILY':
      default:
        return dailyRanking;
    }
  }

  InvitationRankingState copyWith({
    bool? isLoading,
    String? timeRange,
    List<InviteRanking>? dailyRanking,
    List<InviteRanking>? weeklyRanking,
    List<InviteRanking>? monthlyRanking,
    UserInfo? userInfo,
    DbFailure? failure,
  }) {
    return InvitationRankingState(
      isLoading: isLoading ?? this.isLoading,
      timeRange: timeRange ?? this.timeRange,
      dailyRanking: dailyRanking ?? this.dailyRanking,
      weeklyRanking: weeklyRanking ?? this.weeklyRanking,
      monthlyRanking: monthlyRanking ?? this.monthlyRanking,
      userInfo: userInfo ?? this.userInfo,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [isLoading, timeRange, dailyRanking, weeklyRanking, monthlyRanking, userInfo, failure];
}
