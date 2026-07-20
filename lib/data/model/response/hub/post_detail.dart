import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_detail.g.dart';

@JsonSerializable()
class PostDetail {
  final int id;
  final int? userId;
  final String? expertTitle;
  final String? expertAvatar;
  final List<String>? topicTags;
  final String? postTitle;
  final String? postContent;
  final List<String>? postImgs;
  final int? postViewCount;
  final int? postLikeCount;
  final int? postCommentCount;
  final int? postShareCount;
  final int? postStatus;
  final int? createTime;
  final bool? isOwn;

  PostDetail({
    required this.id,
    this.userId,
    this.expertTitle,
    this.expertAvatar,
    this.topicTags,
    this.postTitle,
    this.postContent,
    this.postImgs,
    this.postViewCount,
    this.postLikeCount,
    this.postCommentCount,
    this.postShareCount,
    this.postStatus,
    this.createTime,
    this.isOwn,
  });

  factory PostDetail.fromJson(Map<String, dynamic> json) =>
      _$PostDetailFromJson(json);

  Map<String, dynamic> toJson() => _$PostDetailToJson(this);
}

extension PostDetailExtension on PostDetail {
  String get displayCreateTime => createTime != null
      ? UtcUtils.toDateTimeStr(createTime, format: AppDateTimeFormat.full)
      : "";
}

