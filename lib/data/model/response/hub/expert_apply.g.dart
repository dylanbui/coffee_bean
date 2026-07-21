// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expert_apply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpertApply _$ExpertApplyFromJson(Map<String, dynamic> json) => ExpertApply(
  id: (json['id'] as num).toInt(),
  applyStatus: (json['applyStatus'] as num).toInt(),
  reviewRemark: json['reviewRemark'] as String?,
  createTime: json['createTime'],
);

Map<String, dynamic> _$ExpertApplyToJson(ExpertApply instance) =>
    <String, dynamic>{
      'id': instance.id,
      'applyStatus': instance.applyStatus,
      'reviewRemark': instance.reviewRemark,
      'createTime': instance.createTime,
    };
