// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  userNickname: json['userNickname'] as String?,
  userAvatar: json['userAvatar'] as String?,
  topicTags: (json['topicTags'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  postTitle: json['postTitle'] as String?,
  postImgs: (json['postImgs'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  viewCount: (json['viewCount'] as num?)?.toInt(),
  postLikeCount: (json['postLikeCount'] as num?)?.toInt(),
  postCommentCount: (json['postCommentCount'] as num?)?.toInt(),
  postStatus: (json['postStatus'] as num?)?.toInt(),
  createTime: json['createTime'] as String?,
);

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'userNickname': instance.userNickname,
  'userAvatar': instance.userAvatar,
  'topicTags': instance.topicTags,
  'postTitle': instance.postTitle,
  'postImgs': instance.postImgs,
  'viewCount': instance.viewCount,
  'postLikeCount': instance.postLikeCount,
  'postCommentCount': instance.postCommentCount,
  'postStatus': instance.postStatus,
  'createTime': instance.createTime,
};
