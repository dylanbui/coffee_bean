import 'package:json_annotation/json_annotation.dart';

part 'topic_detail.g.dart';

@JsonSerializable()
class TopicDetail {
  final int id;
  final String? topicName;
  final String? topicIcon;
  final String? topicDesc;
  final int? topicPostCount;
  final int? topicViewCount;
  final int? topicLikeCount;
  final int? topicCommentCount;
  final int? topicSort;
  final int? topicStatus;

  TopicDetail({
    required this.id,
    this.topicName,
    this.topicIcon,
    this.topicDesc,
    this.topicPostCount,
    this.topicViewCount,
    this.topicLikeCount,
    this.topicCommentCount,
    this.topicSort,
    this.topicStatus,
  });

  factory TopicDetail.fromJson(Map<String, dynamic> json) =>
      _$TopicDetailFromJson(json);

  Map<String, dynamic> toJson() => _$TopicDetailToJson(this);
}
