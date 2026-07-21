import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:json_annotation/json_annotation.dart';

part 'point_breakdown.g.dart';

@JsonSerializable()
class PointBreakdownItem {
  final int id;
  final String title;
  final String? description;
  final int point;
  final dynamic createTime;

  PointBreakdownItem({
    required this.id,
    required this.title,
    this.description,
    required this.point,
    required this.createTime,
  });

  factory PointBreakdownItem.fromJson(Map<String, dynamic> json) => _$PointBreakdownItemFromJson(json);
  Map<String, dynamic> toJson() => _$PointBreakdownItemToJson(this);
}

extension PointBreakdownItemExtension on PointBreakdownItem {
  String get displayTime => createTime != null 
    ? UtcUtils.toDateTimeStr(createTime, format: AppDateTimeFormat.fullDatetimeYearFirst)
    : "";
}
