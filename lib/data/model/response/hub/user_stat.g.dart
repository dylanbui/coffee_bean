// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStat _$UserStatFromJson(Map<String, dynamic> json) => UserStat(
  userId: (json['userId'] as num?)?.toInt(),
  statPostCount: (json['statPostCount'] as num?)?.toInt() ?? 0,
  statFansCount: (json['statFansCount'] as num?)?.toInt() ?? 0,
  statFollowCount: (json['statFollowCount'] as num?)?.toInt() ?? 0,
  statPostLikeCount: (json['statPostLikeCount'] as num?)?.toInt() ?? 0,
  statIsExpert: json['statIsExpert'] as bool? ?? false,
);

Map<String, dynamic> _$UserStatToJson(UserStat instance) => <String, dynamic>{
  'userId': instance.userId,
  'statPostCount': instance.statPostCount,
  'statFansCount': instance.statFansCount,
  'statFollowCount': instance.statFollowCount,
  'statPostLikeCount': instance.statPostLikeCount,
  'statIsExpert': instance.statIsExpert,
};
