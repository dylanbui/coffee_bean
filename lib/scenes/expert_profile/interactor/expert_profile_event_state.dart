import 'package:coffee_bean/data/model/response/hub/expert_info.dart';
import 'package:coffee_bean/data/model/response/hub/user_stat.dart';
import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:coffee_bean/data/model/response/hub/course_info.dart';
import 'package:db_core/db_core.dart';

class ExpertProfileState extends BaseBlocState {
  final bool isLoading;
  final DbFailure? failure;
  final ExpertInfo? expertInfo;
  final UserStat? userStat;
  final List<Post> posts;
  final List<CourseInfo> courses;
  final int currentTabIndex;
  
  // UI States not in API
  final bool isFollowed;
  final bool isCurrentUser;

  ExpertProfileState({
    this.isLoading = false,
    this.failure,
    this.expertInfo,
    this.userStat,
    this.posts = const [],
    this.courses = const [],
    this.currentTabIndex = 0,
    this.isFollowed = false,
    this.isCurrentUser = false,
  });

  @override
  List<Object?> get props => [
        isLoading,
        failure,
        expertInfo,
        userStat,
        posts,
        courses,
        currentTabIndex,
        isFollowed,
        isCurrentUser,
      ];

  ExpertProfileState copyWith({
    bool? isLoading,
    DbFailure? failure,
    ExpertInfo? expertInfo,
    UserStat? userStat,
    List<Post>? posts,
    List<CourseInfo>? courses,
    int? currentTabIndex,
    bool? isFollowed,
    bool? isCurrentUser,
  }) {
    return ExpertProfileState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
      expertInfo: expertInfo ?? this.expertInfo,
      userStat: userStat ?? this.userStat,
      posts: posts ?? this.posts,
      courses: courses ?? this.courses,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      isFollowed: isFollowed ?? this.isFollowed,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }
}
