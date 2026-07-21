// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_breakdown.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointBreakdownItem _$PointBreakdownItemFromJson(Map<String, dynamic> json) =>
    PointBreakdownItem(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      point: (json['point'] as num).toInt(),
      createTime: json['createTime'],
    );

Map<String, dynamic> _$PointBreakdownItemToJson(PointBreakdownItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'point': instance.point,
      'createTime': instance.createTime,
    };
