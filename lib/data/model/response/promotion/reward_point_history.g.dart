// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_point_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardPointHistoryItem _$RewardPointHistoryItemFromJson(
  Map<String, dynamic> json,
) => RewardPointHistoryItem(
  title: json['title'] as String,
  body: json['body'] as String?,
  points: (json['points'] as num).toDouble(),
  dateTime: json['dateTime'] as String,
  isVoucher: json['isVoucher'] as bool? ?? false,
);

Map<String, dynamic> _$RewardPointHistoryItemToJson(
  RewardPointHistoryItem instance,
) => <String, dynamic>{
  'title': instance.title,
  'body': instance.body,
  'points': instance.points,
  'dateTime': instance.dateTime,
  'isVoucher': instance.isVoucher,
};
