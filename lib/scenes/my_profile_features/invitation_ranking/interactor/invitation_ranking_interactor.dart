import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/model/response/user/invite_models.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_ranking/interactor/invitation_ranking_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_ranking/interactor/mock_data.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_ranking/invitation_ranking_builder.dart';
import 'package:db_core/db_core.dart';

class InvitationRankingInteractor extends CubitInteractor<InvitationRankingRoutable, InvitationRankingState> {
  final UserRepository _userRepository = locator.get<UserRepository>();

  InvitationRankingInteractor(InvitationRankingRoutable router) 
      : super(InvitationRankingState(userInfo: UserManager().userInfo), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    fetchAllRankings();
  }

  Future<void> fetchAllRankings() async {
    emit(state.copyWith(isLoading: true));

    // Thực hiện 3 API gọi đồng thời
    final results = await Future.wait([
      _userRepository.getInviteRanking('DAILY'),
      _userRepository.getInviteRanking('WEEKLY'),
      _userRepository.getInviteRanking('MONTHLY'),
    ]);

    final dailyRes = results[0];
    final weeklyRes = results[1];
    final monthlyRes = results[2];

    emit(state.copyWith(
      isLoading: false,
      dailyRanking: _processResult(dailyRes, 'DAILY'),
      weeklyRanking: _processResult(weeklyRes, 'WEEKLY'),
      monthlyRanking: _processResult(monthlyRes, 'MONTHLY'),
    ));
  }

  List<InviteRanking> _processResult(DbResult<List<InviteRanking>> result, String timeRange) {
    if (result case DbSuccess(:final data)) {
      if (data.isNotEmpty) return data;
    }
    // Fallback to mock data if empty or error
    return InvitationRankingMockData.getRanking(timeRange);
  }

  void changeTimeRange(String timeRange) {
    emit(state.copyWith(timeRange: timeRange));
  }
}
