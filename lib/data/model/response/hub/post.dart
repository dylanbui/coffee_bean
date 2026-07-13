import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  final int id;
  final int? userId;
  final String? userNickname;
  final String? userAvatar;
  final List<String>? topicTags;
  final String? postTitle;
  final List<String>? postImgs;
  final int? viewCount;
  final int? postLikeCount;
  final int? postCommentCount;
  final int? postStatus;
  final String? createTime;

  Post({
    required this.id,
    this.userId,
    this.userNickname,
    this.userAvatar,
    this.topicTags,
    this.postTitle,
    this.postImgs,
    this.viewCount,
    this.postLikeCount,
    this.postCommentCount,
    this.postStatus,
    this.createTime,
  });

  factory Post.fromJson(Map<String, dynamic> json) =>
      _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
