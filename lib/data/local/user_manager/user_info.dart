import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserLevel {
  final int id;
  final String name;
  final int level;
  final String? icon;

  UserLevel({
    required this.id,
    required this.name,
    required this.level,
    this.icon,
  });

  factory UserLevel.fromJson(Map<String, dynamic> json) => _$UserLevelFromJson(json);
  Map<String, dynamic> toJson() => _$UserLevelToJson(this);
}

@JsonSerializable()
class UserInfo {
  final int id;
  final String nickname;
  final String avatar;
  final String mobile;
  final int sex;
  final int point;
  final int experience;
  final UserLevel? level;
  final bool brokerageEnabled;

  UserInfo({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.mobile,
    required this.sex,
    required this.point,
    required this.experience,
    this.level,
    required this.brokerageEnabled,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
