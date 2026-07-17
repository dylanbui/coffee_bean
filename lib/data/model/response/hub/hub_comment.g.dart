// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hub_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HubComment _$HubCommentFromJson(Map<String, dynamic> json) => HubComment(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  userNickname: json['userNickname'] as String?,
  userAvatar: json['userAvatar'] as String?,
  resourceId: (json['resourceId'] as num?)?.toInt(),
  parentId: (json['parentId'] as num?)?.toInt(),
  commentContent: json['commentContent'] as String?,
  createTime: (json['createTime'] as num?)?.toInt(),
  replies: (json['replies'] as List<dynamic>?)
      ?.map((e) => HubComment.fromJson(e as Map<String, dynamic>))
      .toList(),
  isOwn: json['isOwn'] as bool?,
);

Map<String, dynamic> _$HubCommentToJson(HubComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userNickname': instance.userNickname,
      'userAvatar': instance.userAvatar,
      'resourceId': instance.resourceId,
      'parentId': instance.parentId,
      'commentContent': instance.commentContent,
      'createTime': instance.createTime,
      'replies': instance.replies,
      'isOwn': instance.isOwn,
    };
