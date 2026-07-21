import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:db_core/commons_constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity_info.g.dart';

@JsonSerializable()
class ActivityInfo {
  final int id;
  final String activityName;
  final String? activityCover;
  final String? activityDesc;
  final String? activityLocation;
  final int? activityStart;
  final int? activityEnd;
  final int? activityRegStart;
  final int? activityRegEnd;
  final double activityPrice;
  final int? maxPeople;
  final int? currPeople;
  final int? activityStatus;
  final int? activitySort;
  final int? activityType;
  final String? activityDetail;
  final int? merchantId;
  final dynamic createTime;

  ActivityInfo({
    required this.id,
    this.activityName = '',
    this.activityCover,
    this.activityDesc,
    this.activityLocation,
    this.activityStart,
    this.activityEnd,
    this.activityRegStart,
    this.activityRegEnd,
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

  factory ActivityInfo.fromJson(Dictionary json) => _$ActivityInfoFromJson(json);
  Dictionary toJson() => _$ActivityInfoToJson(this);

  String get mainImage => activityCover ?? "";
  String get name => activityName;
}

extension ActivityInfoExtension on ActivityInfo {
  String get displayCreateTime => createTime != null 
    ? UtcUtils.toDateTimeStr(createTime, format: AppDateTimeFormat.fullDatetimeYearFirst)
    : "";
}
