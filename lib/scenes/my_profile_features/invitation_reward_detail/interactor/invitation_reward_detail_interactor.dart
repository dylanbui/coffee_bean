import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_reward_detail/interactor/invitation_reward_detail_event_state.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_reward_detail/interactor/mock_data.dart';
import 'package:coffee_bean/scenes/my_profile_features/invitation_reward_detail/invitation_reward_detail_builder.dart';
import 'package:db_core/db_core.dart';

class InvitationRewardDetailInteractor extends CubitInteractor<InvitationRewardDetailRoutable, InvitationRewardDetailState> {
  final UserRepository _userRepository = locator<UserRepository>();
  static const int _pageSize = 50;

  InvitationRewardDetailInteractor(InvitationRewardDetailRoutable router)
      : super(InvitationRewardDetailState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _fetchData();
  }

  Future<void> _fetchData({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (!state.hasMore || state.isLoadMore) return;
      emit(state.copyWith(isLoadMore: true));
    } else {
      emit(state.copyWith(isLoading: true, pageNo: 1, items: []));
    }

    final pageNo = isLoadMore ? state.pageNo + 1 : 1;
    final result = await _userRepository.getInviteRewardPoints(pageNo: pageNo, pageSize: _pageSize);

    if (result case DbSuccess(data: final pageResult)) {
      final newItems = isLoadMore ? [...state.items, ...pageResult.list] : pageResult.list;
      
      // Fallback to mock if empty on first load (as requested)
      if (newItems.isEmpty && !isLoadMore) {
        emit(state.copyWith(
          isLoading: false,
          items: InvitationRewardMockData.mockRewardDetails,
          hasMore: false,
        ));
        return;
      }

      emit(state.copyWith(
        isLoading: false,
        isLoadMore: false,
        items: newItems,
        pageNo: pageNo,
        hasMore: newItems.length < pageResult.total,
      ));
    } else {
      // Fallback to mock if failed on first load
      if (!isLoadMore) {
        emit(state.copyWith(
          isLoading: false,
          items: InvitationRewardMockData.mockRewardDetails,
          hasMore: false,
        ));
      } else {
        emit(state.copyWith(isLoadMore: false, errorMessage: "Không thể tải thêm dữ liệu"));
      }
    }
  }

  Future<void> refresh() => _fetchData();

  Future<void> loadMore() => _fetchData(isLoadMore: true);
}
