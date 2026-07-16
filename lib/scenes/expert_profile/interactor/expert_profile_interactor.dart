import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/model/response/hub/course_info.dart';
import 'package:coffee_bean/data/model/response/hub/expert_info.dart';
import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:coffee_bean/data/model/response/hub/user_stat.dart';
import 'package:coffee_bean/data/repository/hub_repository.dart';
import 'package:coffee_bean/scenes/expert_profile/expert_profile_builder.dart';
import 'package:coffee_bean/scenes/expert_profile/interactor/expert_profile_event_state.dart';
import 'package:coffee_bean/scenes/expert_profile/interactor/mock_data.dart';
import 'package:db_core/db_core.dart';

class ExpertProfileInteractor extends CubitInteractor<ExpertProfileRoutable, ExpertProfileState> {
  final int? userId;
  final HubRepository _hubRepo = locator.get<HubRepository>();

  ExpertProfileInteractor(ExpertProfileRoutable router, {this.userId}) : super(ExpertProfileState(isCurrentUser: userId == null), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _fetchData();
  }

  Future<void> _fetchData() async {
    emit(state.copyWith(isLoading: true));

    final results = await Future.wait([
      _hubRepo.getExpertInfo(userId),
      _hubRepo.getUserStat(userId),
      _hubRepo.getUserPosts(userId),
      _hubRepo.getUserCourses(userId),
    ]);

    final expertResult = results[0] as DbResult<ExpertInfo>;
    final statResult = results[1] as DbResult<UserStat>;
    final postsResult = results[2] as DbResult<List<Post>>;
    final coursesResult = results[3] as DbResult<List<CourseInfo>>;

    final currentUserId = UserManager().userInfo?.id;
    final isCurrentUser = state.isCurrentUser || (expertResult.isSuccess && expertResult.data?.userId == currentUserId);

    // Handle results and fallback to mock data if empty
    emit(state.copyWith(
      isLoading: false,
      expertInfo: expertResult.isSuccess ? expertResult.data : ExpertProfileMockData.mockExpertInfo,
      userStat: statResult.isSuccess ? statResult.data : ExpertProfileMockData.mockUserStat,
      posts: (postsResult.isSuccess && (postsResult.data != null && postsResult.data!.isNotEmpty))
          ? postsResult.data
          : ExpertProfileMockData.mockPosts,
      courses: (coursesResult.isSuccess && (coursesResult.data != null && coursesResult.data!.isNotEmpty))
          ? coursesResult.data
          : ExpertProfileMockData.mockCourses,
      // For now, these are not in API, so we keep them as default or logic-based
      isFollowed: false, 
      isCurrentUser: isCurrentUser,
    ));
  }

  void onTabChanged(int index) {
    emit(state.copyWith(currentTabIndex: index));
  }

  Future<void> toggleFollow() async {
    if (state.expertInfo == null) return;
    
    final result = await _hubRepo.toggleFollow(state.expertInfo!.id);
    if (result.isSuccess) {
      emit(state.copyWith(isFollowed: !state.isFollowed));
    }
  }

  void onSettingsPressed() {
    iLog("Settings pressed");
  }

  void onShowFanFollowList(int initialTabIndex) {
    router?.openFanFollowList(initialTabIndex: initialTabIndex);
  }

  void onPublishCourse() {
    iLog("Publish course pressed");
  }

  void onApplyExpert() {
    iLog("Apply expert pressed");
  }
}
