import 'package:json_annotation/json_annotation.dart';

part 'hot_topic.g.dart';

@JsonSerializable()
class HotTopic {
  final int id;
  final String? topicName;
  final String? topicIcon;
  final String? topicDesc;

  HotTopic({
    required this.id,
    this.topicName,
    this.topicIcon,
    this.topicDesc,
  });

  factory HotTopic.fromJson(Map<String, dynamic> json) =>
      _$HotTopicFromJson(json);

  Map<String, dynamic> toJson() => _$HotTopicToJson(this);
}
