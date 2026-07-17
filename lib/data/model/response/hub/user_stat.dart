import 'package:json_annotation/json_annotation.dart';

part 'user_stat.g.dart';

@JsonSerializable()
class UserStat {
  final int? userId;
  final int statPostCount;
  final int statFansCount;
  final int statFollowCount;
  final int statPostLikeCount;
  final bool statIsExpert;

  UserStat({
    this.userId,
    this.statPostCount = 0,
    this.statFansCount = 0,
    this.statFollowCount = 0,
    this.statPostLikeCount = 0,
    this.statIsExpert = false,
  });

  factory UserStat.fromJson(Map<String, dynamic> json) => _$UserStatFromJson(json);
  Map<String, dynamic> toJson() => _$UserStatToJson(this);
}
