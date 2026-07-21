import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expert_apply.g.dart';

@JsonSerializable()
class ExpertApply {
  final int id;
  final int applyStatus; // 0=not_yet_apply 1=pending 2=approved 3=rejected
  final String? reviewRemark;
  final dynamic createTime; // UTC timestamp or ISO String

  ExpertApply({
    required this.id,
    required this.applyStatus,
    this.reviewRemark,
    this.createTime,
  });

  factory ExpertApply.fromJson(Map<String, dynamic> json) => _$ExpertApplyFromJson(json);
  Map<String, dynamic> toJson() => _$ExpertApplyToJson(this);
}

extension ExpertApplyExtension on ExpertApply {
  String get displayCreateTime => createTime != null 
    ? UtcUtils.toDateTimeStr(createTime, format: AppDateTimeFormat.fullDatetimeYearFirst)
    : "";
}
