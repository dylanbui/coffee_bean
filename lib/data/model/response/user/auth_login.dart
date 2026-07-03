import 'package:json_annotation/json_annotation.dart';

part 'auth_login.g.dart';

@JsonSerializable()
class AuthLogin {
  final int userId;
  final String accessToken;
  final String refreshToken;
  final int expiresTime;
  final String? openid;

  AuthLogin({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresTime,
    this.openid,
  });

  factory AuthLogin.fromJson(Map<String, dynamic> json) => _$AuthLoginFromJson(json);
  Map<String, dynamic> toJson() => _$AuthLoginToJson(this);
}
