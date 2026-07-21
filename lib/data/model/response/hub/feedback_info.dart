import 'package:coffee_bean/utils/utils_datetime.dart';
import 'package:db_core/commons_constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'feedback_info.g.dart';

@JsonSerializable()
class FeedbackInfo {
  final int id;
  final String? feedbackContent;
  final List<String>? feedbackImgs;
  final String? feedbackStatus;
  final String? feedbackRemark;
  final dynamic createTime;

  FeedbackInfo({
    required this.id,
    this.feedbackContent,
    this.feedbackImgs,
    this.feedbackStatus,
    this.feedbackRemark,
    this.createTime,
  });

  factory FeedbackInfo.fromJson(Dictionary json) => _$FeedbackInfoFromJson(json);
  Dictionary toJson() => _$FeedbackInfoToJson(this);
}

extension FeedbackInfoExtension on FeedbackInfo {
  String get displayCreateTime => createTime != null 
    ? UtcUtils.toDateTimeStr(createTime, format: AppDateTimeFormat.fullDatetimeYearFirst)
    : "";
}
