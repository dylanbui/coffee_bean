import 'package:db_core/db_core.dart';
import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  final int id;
  final String title;
  final String authorName;
  final String authorAvatar;
  final String date;
  final bool isFollowing;
  final List<String>? hashtags;
  final List<String>? images;
  final String contentHtml;
  final int readCount;
  final int commentCount;
  final int likeCount;
  final bool isLiked;
  final bool isSaved;

  const PostModel({
    required this.id,
    required this.title,
    required this.authorName,
    required this.authorAvatar,
    required this.date,
    required this.isFollowing,
    this.hashtags,
    this.images,
    required this.contentHtml,
    required this.readCount,
    required this.commentCount,
    required this.likeCount,
    required this.isLiked,
    required this.isSaved,
  });

  PostModel copyWith({
    int? id,
    bool? isFollowing,
    bool? isLiked,
    bool? isSaved,
    int? likeCount,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title,
      authorName: authorName,
      authorAvatar: authorAvatar,
      date: date,
      isFollowing: isFollowing ?? this.isFollowing,
      hashtags: hashtags,
      images: images,
      contentHtml: contentHtml,
      readCount: readCount,
      commentCount: commentCount,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [id, isFollowing, isLiked, isSaved, likeCount];
}

class PostDetailState extends BaseBlocState with EquatableMixin {
  final PostModel? post;
  final bool isLoading;
  final String? error;

  PostDetailState({
    this.post,
    this.isLoading = false,
    this.error,
  });

  PostDetailState copyWith({
    PostModel? post,
    bool? isLoading,
    String? error,
  }) {
    return PostDetailState(
      post: post ?? this.post,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [post, isLoading, error];
}
