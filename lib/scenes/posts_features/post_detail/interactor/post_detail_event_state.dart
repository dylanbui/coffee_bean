import 'package:coffee_bean/data/model/response/hub/post_detail.dart';
import 'package:db_core/db_core.dart';
import 'package:equatable/equatable.dart';

class PostDetailState extends BaseBlocState with EquatableMixin {
  final PostDetail? post;
  final bool isLiked;
  final bool isFollowed;
  final bool isFavorited;
  final bool isLoading;
  final bool showCommentInput;
  final String? error;

  PostDetailState({
    this.post,
    this.isLiked = false,
    this.isFollowed = false,
    this.isFavorited = false,
    this.isLoading = false,
    this.showCommentInput = false,
    this.error,
  });

  PostDetailState copyWith({
    PostDetail? post,
    bool? isLiked,
    bool? isFollowed,
    bool? isFavorited,
    bool? isLoading,
    bool? showCommentInput,
    String? error,
  }) {
    return PostDetailState(
      post: post ?? this.post,
      isLiked: isLiked ?? this.isLiked,
      isFollowed: isFollowed ?? this.isFollowed,
      isFavorited: isFavorited ?? this.isFavorited,
      isLoading: isLoading ?? this.isLoading,
      showCommentInput: showCommentInput ?? this.showCommentInput,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [post, isLiked, isFollowed, isFavorited, isLoading, showCommentInput, error];
}
