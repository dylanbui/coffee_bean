// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_breakdown.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointBreakdownItem _$PointBreakdownItemFromJson(Map<String, dynamic> json) =>
    PointBreakdownItem(
      title: json['title'] as String,
      body: json['body'] as String?,
      points: (json['points'] as num).toDouble(),
      dateTime: json['dateTime'] as String,
      isVoucher: json['isVoucher'] as bool? ?? false,
    );

Map<String, dynamic> _$PointBreakdownItemToJson(PointBreakdownItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'points': instance.points,
      'dateTime': instance.dateTime,
      'isVoucher': instance.isVoucher,
    };
