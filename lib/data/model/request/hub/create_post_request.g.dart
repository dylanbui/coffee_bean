// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePostRequest _$CreatePostRequestFromJson(Map<String, dynamic> json) =>
    CreatePostRequest(
      postTitle: json['postTitle'] as String,
      postContent: json['postContent'] as String,
      topicTags: (json['topicTags'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      postCover: json['postCover'] as String?,
    );

Map<String, dynamic> _$CreatePostRequestToJson(CreatePostRequest instance) =>
    <String, dynamic>{
      'postTitle': instance.postTitle,
      'postContent': instance.postContent,
      'topicTags': instance.topicTags,
      'postCover': instance.postCover,
    };
