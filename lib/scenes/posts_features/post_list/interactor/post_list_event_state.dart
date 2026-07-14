import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:db_core/db_core.dart';

class PostListState extends BaseBlocState {
  final List<Post> posts;
  final String keyword;
  final bool isLoading;
  final DbFailure? failure;

  PostListState({
    this.posts = const [],
    this.keyword = "",
    this.isLoading = false,
    this.failure,
  });

  @override
  List<Object?> get props => [posts, keyword, isLoading, failure];

  PostListState copyWith({
    List<Post>? posts,
    String? keyword,
    bool? isLoading,
    DbFailure? failure,
  }) {
    return PostListState(
      posts: posts ?? this.posts,
      keyword: keyword ?? this.keyword,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }
}
