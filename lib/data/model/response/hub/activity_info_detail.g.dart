// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_info_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityInfoDetail _$ActivityInfoDetailFromJson(Map<String, dynamic> json) =>
    ActivityInfoDetail(
      id: (json['id'] as num).toInt(),
      activityName: json['activityName'] as String? ?? '',
      activityCover: json['activityCover'] as String?,
      activityDesc: json['activityDesc'] as String?,
      activityLocation: json['activityLocation'] as String?,
      activityStart: (json['activityStart'] as num).toInt(),
      activityEnd: (json['activityEnd'] as num).toInt(),
      activityRegStart: (json['activityRegStart'] as num).toInt(),
      activityRegEnd: (json['activityRegEnd'] as num).toInt(),
      activityPrice: (json['activityPrice'] as num?)?.toDouble() ?? 0.0,
      maxPeople: (json['maxPeople'] as num?)?.toInt(),
      currPeople: (json['currPeople'] as num?)?.toInt(),
      activityStatus: (json['activityStatus'] as num?)?.toInt(),
      activitySort: (json['activitySort'] as num?)?.toInt(),
      activityType: (json['activityType'] as num?)?.toInt(),
      activityDetail: json['activityDetail'] as String?,
      merchantId: (json['merchantId'] as num?)?.toInt(),
      createTime: (json['createTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ActivityInfoDetailToJson(ActivityInfoDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'activityName': instance.activityName,
      'activityCover': instance.activityCover,
      'activityDesc': instance.activityDesc,
      'activityLocation': instance.activityLocation,
      'activityStart': instance.activityStart,
      'activityEnd': instance.activityEnd,
      'activityRegStart': instance.activityRegStart,
      'activityRegEnd': instance.activityRegEnd,
      'activityPrice': instance.activityPrice,
      'maxPeople': instance.maxPeople,
      'currPeople': instance.currPeople,
      'activityStatus': instance.activityStatus,
      'activitySort': instance.activitySort,
      'activityType': instance.activityType,
      'activityDetail': instance.activityDetail,
      'merchantId': instance.merchantId,
      'createTime': instance.createTime,
    };
