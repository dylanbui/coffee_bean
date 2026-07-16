// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follower_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowUser _$FollowUserFromJson(Map<String, dynamic> json) => FollowUser(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  expertTitle: json['expertTitle'] as String?,
  expertDesc: json['expertDesc'] as String?,
  expertAvatar: json['expertAvatar'] as String?,
);

Map<String, dynamic> _$FollowUserToJson(FollowUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'expertTitle': instance.expertTitle,
      'expertDesc': instance.expertDesc,
      'expertAvatar': instance.expertAvatar,
    };
