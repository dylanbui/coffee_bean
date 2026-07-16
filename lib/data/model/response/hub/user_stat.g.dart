// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStat _$UserStatFromJson(Map<String, dynamic> json) => UserStat(
  userId: (json['userId'] as num?)?.toInt(),
  statPostCount: (json['statPostCount'] as num?)?.toInt() ?? 0,
  followerCount: (json['followerCount'] as num?)?.toInt() ?? 0,
  followeeCount: (json['followeeCount'] as num?)?.toInt() ?? 0,
  likeReceivedCount: (json['likeReceivedCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserStatToJson(UserStat instance) => <String, dynamic>{
  'userId': instance.userId,
  'statPostCount': instance.statPostCount,
  'followerCount': instance.followerCount,
  'followeeCount': instance.followeeCount,
  'likeReceivedCount': instance.likeReceivedCount,
};
