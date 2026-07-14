import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:coffee_bean/data/model/response/hub/topic_detail.dart';
import 'package:db_core/db_core.dart';
import 'package:equatable/equatable.dart';

class PostByTopicListState extends BaseBlocState {
  final TopicDetail? topic;
  final List<Post> posts;
  final bool isLoading;
  final int currentTabIndex; // 0: LATEST, 1: HOT

  PostByTopicListState({
    this.topic,
    this.posts = const [],
    this.isLoading = false,
    this.currentTabIndex = 0,
  });

  @override
  List<Object?> get props => [topic, posts, isLoading, currentTabIndex];

  PostByTopicListState copyWith({
    DbFailure? failure,
    TopicDetail? topic,
    List<Post>? posts,
    bool? isLoading,
    int? currentTabIndex,
  }) {
    return PostByTopicListState(
      topic: topic ?? this.topic,
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }
}
