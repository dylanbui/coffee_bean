import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:db_core/db_core.dart';

class PostCardListState extends BaseBlocState {
  final List<Post> posts;
  final bool isLoading;
  final DbFailure? failure;

  PostCardListState({
    this.posts = const [],
    this.isLoading = false,
    this.failure,
  });

  @override
  List<Object?> get props => [posts, isLoading, failure];

  PostCardListState copyWith({
    List<Post>? posts,
    bool? isLoading,
    DbFailure? failure,
  }) {
    return PostCardListState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }
}
