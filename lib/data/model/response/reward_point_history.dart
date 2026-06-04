import 'package:json_annotation/json_annotation.dart';

part 'reward_point_history.g.dart';

@JsonSerializable()
class RewardPointHistoryItem {
  final String title;
  final String? body;
  final double points;
  final String dateTime;
  final bool isVoucher;

  RewardPointHistoryItem({
    required this.title,
    this.body,
    required this.points,
    required this.dateTime,
    this.isVoucher = false,
  });

  factory RewardPointHistoryItem.fromJson(Map<String, dynamic> json) => _$RewardPointHistoryItemFromJson(json);
  Map<String, dynamic> toJson() => _$RewardPointHistoryItemToJson(this);
}
