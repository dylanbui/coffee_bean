import 'package:coffee_bean/utils/utils_datetime.dart';
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
  final String? postContent;
  final String? postDesc;
  final List<String>? postImgs;
  final int? viewCount;
  final int? postLikeCount;
  final int? postCommentCount;
  final int? postShareCount;
  final int? postStatus;
  final int? createTime;

  Post({
    required this.id,
    this.userId,
    this.userNickname,
    this.userAvatar,
    this.topicTags,
    this.postTitle,
    this.postContent,
    this.postDesc,
    this.postImgs,
    this.viewCount,
    this.postLikeCount,
    this.postCommentCount,
    this.postShareCount,
    this.postStatus,
    this.createTime,
  });

  String get displayCreateTime => createTime != null 
    ? UtcUtils.toDateTimeStr(createTime, format: AppDateTimeFormat.full) 
    : "";

  factory Post.fromJson(Map<String, dynamic> json) =>
      _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

