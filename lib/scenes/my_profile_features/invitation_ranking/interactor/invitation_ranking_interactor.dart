import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_ranking/interactor/invitation_ranking_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_ranking/interactor/mock_data.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_ranking/invitation_ranking_builder.dart';
import 'package:db_core/db_core.dart';

class InvitationRankingInteractor extends CubitInteractor<InvitationRankingRoutable, InvitationRankingState> {
  final UserRepository _userRepository = locator.get<UserRepository>();

  InvitationRankingInteractor(InvitationRankingRoutable router) 
      : super(InvitationRankingState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    fetchRanking(state.timeRange);
  }

  Future<void> fetchRanking(String timeRange) async {
    emit(state.copyWith(isLoading: true, timeRange: timeRange));

    final result = await _userRepository.getInviteRanking(timeRange);

    if (result case DbSuccess(:final data)) {
      if (data.isEmpty) {
        // Fallback to mock data if empty
        emit(state.copyWith(
          isLoading: false,
          rankingList: InvitationRankingMockData.getRanking(timeRange),
        ));
      } else {
        emit(state.copyWith(isLoading: false, rankingList: data));
      }
    } else if (result case DbFailure()) {
      // Fallback to mock data on error as requested
      emit(state.copyWith(
        isLoading: false,
        rankingList: InvitationRankingMockData.getRanking(timeRange),
        // We can still keep the failure if needed for UI, but here we prioritize showing mock data
      ));
    }
  }
}
