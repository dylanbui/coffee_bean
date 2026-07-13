// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hot_topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HotTopic _$HotTopicFromJson(Map<String, dynamic> json) => HotTopic(
  id: (json['id'] as num).toInt(),
  topicName: json['topicName'] as String?,
  topicIcon: json['topicIcon'] as String?,
  topicDesc: json['topicDesc'] as String?,
);

Map<String, dynamic> _$HotTopicToJson(HotTopic instance) => <String, dynamic>{
  'id': instance.id,
  'topicName': instance.topicName,
  'topicIcon': instance.topicIcon,
  'topicDesc': instance.topicDesc,
};
