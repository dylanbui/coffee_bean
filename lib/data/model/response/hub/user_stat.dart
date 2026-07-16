import 'package:json_annotation/json_annotation.dart';

part 'user_stat.g.dart';

@JsonSerializable()
class UserStat {
  final int? userId;
  final int statPostCount;
  final int followerCount;
  final int followeeCount;
  final int likeReceivedCount;

  UserStat({
    this.userId,
    this.statPostCount = 0,
    this.followerCount = 0,
    this.followeeCount = 0,
    this.likeReceivedCount = 0,
  });

  factory UserStat.fromJson(Map<String, dynamic> json) => _$UserStatFromJson(json);
  Map<String, dynamic> toJson() => _$UserStatToJson(this);
}
