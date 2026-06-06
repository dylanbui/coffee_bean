import 'package:json_annotation/json_annotation.dart';

part 'point_breakdown.g.dart';

@JsonSerializable()
class PointBreakdownItem {
  final String title;
  final String? body;
  final double points;
  final String dateTime;
  final bool isVoucher;

  PointBreakdownItem({
    required this.title,
    this.body,
    required this.points,
    required this.dateTime,
    this.isVoucher = false,
  });

  factory PointBreakdownItem.fromJson(Map<String, dynamic> json) => _$PointBreakdownItemFromJson(json);
  Map<String, dynamic> toJson() => _$PointBreakdownItemToJson(this);
}
