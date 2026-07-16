import 'package:json_annotation/json_annotation.dart';

part 'expert_info.g.dart';

@JsonSerializable()
class ExpertInfo {
  final int id;
  final int? userId;
  final String? userNickname;
  final String? userAvatar;
  final String? expertTitle;
  final String? expertIntro;
  final int? expertStatus; // 0-disabled 1-enabled
  final int? followerCount;

  ExpertInfo({
    required this.id,
    this.userId,
    this.userNickname,
    this.userAvatar,
    this.expertTitle,
    this.expertIntro,
    this.expertStatus,
    this.followerCount,
  });

  factory ExpertInfo.fromJson(Map<String, dynamic> json) => _$ExpertInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertInfoToJson(this);
}
