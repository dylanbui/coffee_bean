import 'package:db_core/commons_constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'announcement.g.dart';

@JsonSerializable()
class Announcement {
  final int id;
  final String title;
  final int type;
  final String content;
  final int? createTime;

  Announcement({
    required this.id,
    required this.title,
    required this.type,
    required this.content,
    this.createTime,
  });

  factory Announcement.fromJson(Dictionary json) => _$AnnouncementFromJson(json);

  Dictionary toJson() => _$AnnouncementToJson(this);
}
