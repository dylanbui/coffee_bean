// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicDetail _$TopicDetailFromJson(Map<String, dynamic> json) => TopicDetail(
  id: (json['id'] as num).toInt(),
  topicName: json['topicName'] as String?,
  topicIcon: json['topicIcon'] as String?,
  topicDesc: json['topicDesc'] as String?,
  topicPostCount: (json['topicPostCount'] as num?)?.toInt(),
  topicViewCount: (json['topicViewCount'] as num?)?.toInt(),
  topicLikeCount: (json['topicLikeCount'] as num?)?.toInt(),
  topicCommentCount: (json['topicCommentCount'] as num?)?.toInt(),
  topicSort: (json['topicSort'] as num?)?.toInt(),
  topicStatus: (json['topicStatus'] as num?)?.toInt(),
);

Map<String, dynamic> _$TopicDetailToJson(TopicDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topicName': instance.topicName,
      'topicIcon': instance.topicIcon,
      'topicDesc': instance.topicDesc,
      'topicPostCount': instance.topicPostCount,
      'topicViewCount': instance.topicViewCount,
      'topicLikeCount': instance.topicLikeCount,
      'topicCommentCount': instance.topicCommentCount,
      'topicSort': instance.topicSort,
      'topicStatus': instance.topicStatus,
    };
