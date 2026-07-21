import 'package:json_annotation/json_annotation.dart';

part 'follower_user.g.dart';

@JsonSerializable()
class FollowUser {
  final int? id;
  final int? userId;
  final String? expertTitle;
  final String? expertDesc;
  final String? expertAvatar;

  FollowUser({
    this.id,
    this.userId,
    this.expertTitle,
    this.expertDesc,
    this.expertAvatar,
  });

  factory FollowUser.fromJson(Map<String, dynamic> json) => _$FollowUserFromJson(json);

  Map<String, dynamic> toJson() => _$FollowUserToJson(this);
}
