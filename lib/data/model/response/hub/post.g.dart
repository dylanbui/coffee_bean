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
  postContent: json['postContent'] as String?,
  postDesc: json['postDesc'] as String?,
  postImgs: (json['postImgs'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  viewCount: (json['viewCount'] as num?)?.toInt(),
  postLikeCount: (json['postLikeCount'] as num?)?.toInt(),
  postCommentCount: (json['postCommentCount'] as num?)?.toInt(),
  postShareCount: (json['postShareCount'] as num?)?.toInt(),
  postStatus: (json['postStatus'] as num?)?.toInt(),
  createTime: json['createTime'],
);

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'userNickname': instance.userNickname,
  'userAvatar': instance.userAvatar,
  'topicTags': instance.topicTags,
  'postTitle': instance.postTitle,
  'postContent': instance.postContent,
  'postDesc': instance.postDesc,
  'postImgs': instance.postImgs,
  'viewCount': instance.viewCount,
  'postLikeCount': instance.postLikeCount,
  'postCommentCount': instance.postCommentCount,
  'postShareCount': instance.postShareCount,
  'postStatus': instance.postStatus,
  'createTime': instance.createTime,
};
