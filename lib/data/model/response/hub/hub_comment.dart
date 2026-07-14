import 'package:json_annotation/json_annotation.dart';

part 'hub_comment.g.dart';

@JsonSerializable()
class HubComment {
  final int id;
  final int? userId;
  final String? userNickname;
  final String? userAvatar;
  final int? resourceId;
  final int? parentId;
  final String? commentContent;
  final String? createTime;
  final List<HubComment>? replies;
  final bool? isOwn;

  HubComment({
    required this.id,
    this.userId,
    this.userNickname,
    this.userAvatar,
    this.resourceId,
    this.parentId,
    this.commentContent,
    this.createTime,
    this.replies,
    this.isOwn,
  });

  factory HubComment.fromJson(Map<String, dynamic> json) =>
      _$HubCommentFromJson(json);

  Map<String, dynamic> toJson() => _$HubCommentToJson(this);
}
