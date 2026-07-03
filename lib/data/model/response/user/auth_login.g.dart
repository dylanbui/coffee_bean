// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthLogin _$AuthLoginFromJson(Map<String, dynamic> json) => AuthLogin(
  userId: (json['userId'] as num).toInt(),
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  expiresTime: (json['expiresTime'] as num).toInt(),
  openid: json['openid'] as String?,
);

Map<String, dynamic> _$AuthLoginToJson(AuthLogin instance) => <String, dynamic>{
  'userId': instance.userId,
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'expiresTime': instance.expiresTime,
  'openid': instance.openid,
};
