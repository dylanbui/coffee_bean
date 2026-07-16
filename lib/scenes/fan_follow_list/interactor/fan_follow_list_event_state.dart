import 'package:coffee_bean/data/models/response/hub/follower_user.dart';
import 'package:db_core/db_core.dart';

class FanFollowListState extends BaseBlocState {
  final bool isLoading;
  final DbFailure? failure;
  final List<FollowUser> followers;
  final List<FollowUser> following;
  final int currentTabIndex;

  FanFollowListState({
    this.isLoading = false,
    this.failure,
    this.followers = const [],
    this.following = const [],
    this.currentTabIndex = 0,
  });

  @override
  List<Object?> get props => [
        isLoading,
        failure,
        followers,
        following,
        currentTabIndex,
      ];

  FanFollowListState copyWith({
    bool? isLoading,
    DbFailure? failure,
    List<FollowUser>? followers,
    List<FollowUser>? following,
    int? currentTabIndex,
  }) {
    return FanFollowListState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }
}
