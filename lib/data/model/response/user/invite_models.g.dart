// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InviteOverview _$InviteOverviewFromJson(Map<String, dynamic> json) =>
    InviteOverview(
      inviteCode: json['inviteCode'] as String?,
      totalInvites: (json['totalInvites'] as num?)?.toInt() ?? 0,
      totalRewardPoints: (json['totalRewardPoints'] as num?)?.toInt() ?? 0,
      todayInvites: (json['todayInvites'] as num?)?.toInt() ?? 0,
      todayRewardPoints: (json['todayRewardPoints'] as num?)?.toInt() ?? 0,
      pendingCount: (json['pendingCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$InviteOverviewToJson(InviteOverview instance) =>
    <String, dynamic>{
      'inviteCode': instance.inviteCode,
      'totalInvites': instance.totalInvites,
      'totalRewardPoints': instance.totalRewardPoints,
      'todayInvites': instance.todayInvites,
      'todayRewardPoints': instance.todayRewardPoints,
      'pendingCount': instance.pendingCount,
    };

InviteRewardConfig _$InviteRewardConfigFromJson(Map<String, dynamic> json) =>
    InviteRewardConfig(
      eachInvitePoints: (json['eachInvitePoints'] as num?)?.toInt() ?? 0,
      firstInviteBonus: (json['firstInviteBonus'] as num?)?.toInt() ?? 0,
      dailyLimit: (json['dailyLimit'] as num?)?.toInt() ?? 0,
      totalLimit: (json['totalLimit'] as num?)?.toInt() ?? 0,
      inviteExpireDays: (json['inviteExpireDays'] as num?)?.toInt() ?? 0,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$InviteRewardConfigToJson(InviteRewardConfig instance) =>
    <String, dynamic>{
      'eachInvitePoints': instance.eachInvitePoints,
      'firstInviteBonus': instance.firstInviteBonus,
      'dailyLimit': instance.dailyLimit,
      'totalLimit': instance.totalLimit,
      'inviteExpireDays': instance.inviteExpireDays,
      'description': instance.description,
    };
