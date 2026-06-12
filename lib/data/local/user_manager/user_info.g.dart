// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLevel _$UserLevelFromJson(Map<String, dynamic> json) => UserLevel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  level: (json['level'] as num).toInt(),
  icon: json['icon'] as String?,
);

Map<String, dynamic> _$UserLevelToJson(UserLevel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'level': instance.level,
  'icon': instance.icon,
};

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
  id: (json['id'] as num).toInt(),
  nickname: json['nickname'] as String,
  avatar: json['avatar'] as String,
  mobile: json['mobile'] as String,
  sex: (json['sex'] as num).toInt(),
  point: (json['point'] as num).toInt(),
  experience: (json['experience'] as num).toInt(),
  level: json['level'] == null
      ? null
      : UserLevel.fromJson(json['level'] as Map<String, dynamic>),
  brokerageEnabled: json['brokerageEnabled'] as bool,
);

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
  'id': instance.id,
  'nickname': instance.nickname,
  'avatar': instance.avatar,
  'mobile': instance.mobile,
  'sex': instance.sex,
  'point': instance.point,
  'experience': instance.experience,
  'level': instance.level,
  'brokerageEnabled': instance.brokerageEnabled,
};
