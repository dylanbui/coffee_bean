// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSession _$UserSessionFromJson(Map<String, dynamic> json) => UserSession(
  id: (json['id'] as num).toInt(),
  userName: json['userName'] as String?,
  email: json['email'] as String?,
  password: json['password'] as String?,
  fullName: json['fullName'] as String?,
  accessToken: json['accessToken'] as String?,
  refreshToken: json['refreshToken'] as String?,
);

Map<String, dynamic> _$UserSessionToJson(UserSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'email': instance.email,
      'password': instance.password,
      'fullName': instance.fullName,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
