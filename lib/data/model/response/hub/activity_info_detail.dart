import 'package:db_core/commons_constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity_info_detail.g.dart';

@JsonSerializable()
class ActivityInfoDetail {
  final int id;
  final String activityName;
  final String? activityCover;
  final String? activityDesc;
  final String? activityLocation;
  final int activityStart;
  final int activityEnd;
  final int activityRegStart;
  final int activityRegEnd;
  final double activityPrice;
  final int? maxPeople;
  final int? currPeople;
  final int? activityStatus;
  final int? activitySort;
  final int? activityType;
  final String? activityDetail;
  final int? merchantId;
  final int? createTime;

  ActivityInfoDetail({
    required this.id,
    this.activityName = '',
    this.activityCover,
    this.activityDesc,
    this.activityLocation,
    required this.activityStart,
    required this.activityEnd,
    required this.activityRegStart,
    required this.activityRegEnd,
    this.activityPrice = 0.0,
    this.maxPeople,
    this.currPeople,
    this.activityStatus,
    this.activitySort,
    this.activityType,
    this.activityDetail,
    this.merchantId,
    this.createTime,
  });

  factory ActivityInfoDetail.fromJson(Dictionary json) => _$ActivityInfoDetailFromJson(json);
  Dictionary toJson() => _$ActivityInfoDetailToJson(this);

  String get mainImage => activityCover ?? "";
  String get name => activityName;
}
