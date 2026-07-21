import 'package:coffee_bean/utils/utils_datetime.dart';
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

@JsonSerializable()
class InviteRanking {
  final int rank;
  final int userId;
  final String? nickname;
  final String? avatar;
  final int totalInvites;
  final String? mobile; // Added based on design, might be null from API

  InviteRanking({
    this.rank = 0,
    this.userId = 0,
    this.nickname,
    this.avatar,
    this.totalInvites = 0,
    this.mobile,
  });

  factory InviteRanking.fromJson(Map<String, dynamic> json) => _$InviteRankingFromJson(json);
  Map<String, dynamic> toJson() => _$InviteRankingToJson(this);
}

@JsonSerializable()
class InviteRecord {
  final int? inviteeId;
  final String? nickname;
  final String? avatar;
  final int? status;
  final String? statusName;
  final dynamic registerTime;
  final int? rewardPoints;
  final dynamic rewardTime;
  final dynamic createTime;

  InviteRecord({
    this.inviteeId,
    this.nickname,
    this.avatar,
    this.status,
    this.statusName,
    this.registerTime,
    this.rewardPoints,
    this.rewardTime,
    required this.createTime,
  });

  factory InviteRecord.fromJson(Map<String, dynamic> json) => _$InviteRecordFromJson(json);
  Map<String, dynamic> toJson() => _$InviteRecordToJson(this);
}

extension InviteRecordExtension on InviteRecord {
  String get displayCreateTime => createTime != null 
    ? UtcUtils.toDateTimeStr(createTime, format: AppDateTimeFormat.fullDatetimeYearFirst)
    : "";
}
