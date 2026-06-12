import 'package:json_annotation/json_annotation.dart';

part 'auth_login_response.g.dart';

@JsonSerializable()
class AuthLoginResponse {
  final int userId;
  final String accessToken;
  final String refreshToken;
  final String expiresTime;
  final String? openid;

  AuthLoginResponse({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresTime,
    this.openid,
  });

  factory AuthLoginResponse.fromJson(Map<String, dynamic> json) => _$AuthLoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthLoginResponseToJson(this);
}
