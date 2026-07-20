import 'package:json_annotation/json_annotation.dart';

part 'invite_models.g.dart';

@JsonSerializable()
class InviteOverview {
  final String? inviteCode;
  final int totalInvites;
  final int totalRewardPoints;
  final int todayInvites;
  final int todayRewardPoints;
  final int pendingCount;

  InviteOverview({
    this.inviteCode,
    this.totalInvites = 0,
    this.totalRewardPoints = 0,
    this.todayInvites = 0,
    this.todayRewardPoints = 0,
    this.pendingCount = 0,
  });

  factory InviteOverview.fromJson(Map<String, dynamic> json) => _$InviteOverviewFromJson(json);
  Map<String, dynamic> toJson() => _$InviteOverviewToJson(this);
}

@JsonSerializable()
class InviteRewardConfig {
  final int eachInvitePoints;
  final int firstInviteBonus;
  final int dailyLimit;
  final int totalLimit;
  final int inviteExpireDays;
  final String? description;

  InviteRewardConfig({
    this.eachInvitePoints = 0,
    this.firstInviteBonus = 0,
    this.dailyLimit = 0,
    this.totalLimit = 0,
    this.inviteExpireDays = 0,
    this.description,
  });

  factory InviteRewardConfig.fromJson(Map<String, dynamic> json) => _$InviteRewardConfigFromJson(json);
  Map<String, dynamic> toJson() => _$InviteRewardConfigToJson(this);
}
