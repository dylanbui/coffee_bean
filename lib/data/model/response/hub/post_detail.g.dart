// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDetail _$PostDetailFromJson(Map<String, dynamic> json) => PostDetail(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  expertTitle: json['expertTitle'] as String?,
  expertAvatar: json['expertAvatar'] as String?,
  topicTags: (json['topicTags'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  postTitle: json['postTitle'] as String?,
  postContent: json['postContent'] as String?,
  postImgs: (json['postImgs'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  postViewCount: (json['postViewCount'] as num?)?.toInt(),
  postLikeCount: (json['postLikeCount'] as num?)?.toInt(),
  postCommentCount: (json['postCommentCount'] as num?)?.toInt(),
  postShareCount: (json['postShareCount'] as num?)?.toInt(),
  postStatus: (json['postStatus'] as num?)?.toInt(),
  createTime: json['createTime'],
  isOwn: json['isOwn'] as bool?,
);

Map<String, dynamic> _$PostDetailToJson(PostDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'expertTitle': instance.expertTitle,
      'expertAvatar': instance.expertAvatar,
      'topicTags': instance.topicTags,
      'postTitle': instance.postTitle,
      'postContent': instance.postContent,
      'postImgs': instance.postImgs,
      'postViewCount': instance.postViewCount,
      'postLikeCount': instance.postLikeCount,
      'postCommentCount': instance.postCommentCount,
      'postShareCount': instance.postShareCount,
      'postStatus': instance.postStatus,
      'createTime': instance.createTime,
      'isOwn': instance.isOwn,
    };
