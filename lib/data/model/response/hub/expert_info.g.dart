// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expert_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpertInfo _$ExpertInfoFromJson(Map<String, dynamic> json) => ExpertInfo(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  userNickname: json['userNickname'] as String?,
  userAvatar: json['userAvatar'] as String?,
  expertTitle: json['expertTitle'] as String?,
  expertIntro: json['expertIntro'] as String?,
  expertStatus: (json['expertStatus'] as num?)?.toInt(),
  followerCount: (json['followerCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$ExpertInfoToJson(ExpertInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userNickname': instance.userNickname,
      'userAvatar': instance.userAvatar,
      'expertTitle': instance.expertTitle,
      'expertIntro': instance.expertIntro,
      'expertStatus': instance.expertStatus,
      'followerCount': instance.followerCount,
    };
