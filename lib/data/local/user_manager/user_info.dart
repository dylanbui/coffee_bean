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

  UserLevel copyWith({
    int? id,
    String? name,
    int? level,
    String? icon,
  }) {
    return UserLevel(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      icon: icon ?? this.icon,
    );
  }
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
  final bool? brokerageEnabled; // Allow true/false/null

  UserInfo({
    required this.id,
    required this.nickname,
    required String avatar,
    required this.mobile,
    required this.sex,
    required this.point,
    required this.experience,
    this.level,
    this.brokerageEnabled,
  }) : avatar = avatar.isEmpty ? "https://i.pravatar.cc/150?img=19" : avatar;

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

  UserInfo copyWith({
    int? id,
    String? nickname,
    String? avatar,
    String? mobile,
    int? sex,
    int? point,
    int? experience,
    UserLevel? level,
    bool? brokerageEnabled,
  }) {
    return UserInfo(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      mobile: mobile ?? this.mobile,
      sex: sex ?? this.sex,
      point: point ?? this.point,
      experience: experience ?? this.experience,
      level: level ?? this.level,
      brokerageEnabled: brokerageEnabled ?? this.brokerageEnabled,
    );
  }
}
