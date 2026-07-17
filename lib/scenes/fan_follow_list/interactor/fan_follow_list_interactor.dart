import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/models/response/hub/follower_user.dart';
import 'package:coffee_bean/data/network/page_result.dart';
import 'package:coffee_bean/data/repository/hub_repository.dart';
import 'package:coffee_bean/scenes/fan_follow_list/fan_follow_list_builder.dart';
import 'package:coffee_bean/scenes/fan_follow_list/interactor/fan_follow_list_event_state.dart';
import 'package:coffee_bean/scenes/fan_follow_list/interactor/mock_data.dart';
import 'package:db_core/db_core.dart';

class FanFollowListInteractor extends CubitInteractor<FanFollowListRoutable, FanFollowListState> {
  final HubRepository _hubRepository = locator.get<HubRepository>() ;

  FanFollowListInteractor(FanFollowListRoutable router, {int initialTabIndex = 0}) 
      : super(FanFollowListState(currentTabIndex: initialTabIndex), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final user = UserManager().currentUser;
    if (user == null) {
      emit(state.copyWith(isLoading: false, followers: [], following: []));
      return;
    }

    emit(state.copyWith(isLoading: true));

    // Fetch both lists in parallel
    final results = await Future.wait([
      _hubRepository.getFollowerList(userId: user.id),
      _hubRepository.getFolloweeList(userId: user.id),
    ]);

    final followerResult = results[0];
    final followingResult = results[1];

    List<FollowUser> followers = [];
    List<FollowUser> following = [];
    DbFailure? failure;

    if (followerResult case DbFailure()) {
      failure = followerResult;
    } else if (followerResult case DbSuccess(data: final PageResult<FollowUser> data)) {
      followers = data.list;
    }

    if (followingResult case DbFailure()) {
      failure = followingResult;
    } else if (followingResult case DbSuccess(data: final PageResult<FollowUser> data)) {
      following = data.list;
    }

    // Nếu dữ liệu trống thì dùng mock data như yêu cầu
    if (followers.isEmpty) {
      followers = FanFollowMockData.getFollowers();
    }
    if (following.isEmpty) {
      following = FanFollowMockData.getFollowing();
    }

    emit(state.copyWith(
      isLoading: false,
      followers: followers,
      following: following,
      failure: failure,
    ));
  }

  void onTabChanged(int index) {
    emit(state.copyWith(currentTabIndex: index));
  }

  Future<void> onRemoveFollower(FollowUser user) async {
    // Logic: Gỡ người theo dõi
    final newList = List<FollowUser>.from(state.followers)..removeWhere((e) => e.userId == user.userId);
    emit(state.copyWith(followers: newList));
  }

  Future<void> onUnfollow(FollowUser user) async {
    // Logic: Hủy theo dõi
    final result = await _hubRepository.toggleFollow(user.userId ?? 0);
    if (result case DbSuccess()) {
      final newList = List<FollowUser>.from(state.following)..removeWhere((e) => e.userId == user.userId);
      emit(state.copyWith(following: newList));
    }
  }
}
