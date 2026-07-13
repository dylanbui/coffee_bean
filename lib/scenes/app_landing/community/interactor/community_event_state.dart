import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';
import 'package:db_core/db_core.dart';

class CommunityState extends BaseBlocState {
  final bool isLoading;
  final List<HotTopic> hotTopics;
  final List<Post> posts;
  final int currentTabIndex; // 0: Gợi ý, 1: Đề xuất, 2: Thịnh hành
  final NetworkError? failure;

  CommunityState({
    this.isLoading = false,
    this.hotTopics = const [],
    this.posts = const [],
    this.currentTabIndex = 0,
    this.failure,
  });

  CommunityState copyWith({
    bool? isLoading,
    List<HotTopic>? hotTopics,
    List<Post>? posts,
    int? currentTabIndex,
    NetworkError? failure,
  }) {
    return CommunityState(
      isLoading: isLoading ?? this.isLoading,
      hotTopics: hotTopics ?? this.hotTopics,
      posts: posts ?? this.posts,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [isLoading, hotTopics, posts, currentTabIndex, failure];
}
