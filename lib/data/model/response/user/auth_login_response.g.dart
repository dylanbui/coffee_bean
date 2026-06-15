// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthLoginResponse _$AuthLoginResponseFromJson(Map<String, dynamic> json) =>
    AuthLoginResponse(
      userId: (json['userId'] as num).toInt(),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresTime: (json['expiresTime'] as num).toInt(),
      openid: json['openid'] as String?,
    );

Map<String, dynamic> _$AuthLoginResponseToJson(AuthLoginResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresTime': instance.expiresTime,
      'openid': instance.openid,
    };
