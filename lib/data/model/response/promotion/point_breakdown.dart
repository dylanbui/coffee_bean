import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:json_annotation/json_annotation.dart';

part 'point_breakdown.g.dart';

@JsonSerializable()
class PointBreakdownItem {
  final int id;
  final String title;
  final String? description;
  final int point;
  final int createTime;

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
  String get displayTime => UtcUtils.formatTimestamp(createTime, format: AppDateTimeFormat.fullDatetime);
}
