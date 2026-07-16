import 'package:json_annotation/json_annotation.dart';

part 'expert_apply.g.dart';

@JsonSerializable()
class ExpertApply {
  final int id;
  final int applyStatus; // 0-pending 1-approved 2-rejected
  final String? reviewRemark;
  final int? createTime; // UTC timestamp

  ExpertApply({
    required this.id,
    required this.applyStatus,
    this.reviewRemark,
    this.createTime,
  });

  factory ExpertApply.fromJson(Map<String, dynamic> json) => _$ExpertApplyFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertApplyToJson(this);
}
