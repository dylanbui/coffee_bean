// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackInfo _$FeedbackInfoFromJson(Map<String, dynamic> json) => FeedbackInfo(
  id: (json['id'] as num).toInt(),
  feedbackContent: json['feedbackContent'] as String?,
  feedbackImgs: (json['feedbackImgs'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  feedbackStatus: json['feedbackStatus'] as String?,
  feedbackRemark: json['feedbackRemark'] as String?,
  createTime: json['createTime'],
);

Map<String, dynamic> _$FeedbackInfoToJson(FeedbackInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'feedbackContent': instance.feedbackContent,
      'feedbackImgs': instance.feedbackImgs,
      'feedbackStatus': instance.feedbackStatus,
      'feedbackRemark': instance.feedbackRemark,
      'createTime': instance.createTime,
    };
