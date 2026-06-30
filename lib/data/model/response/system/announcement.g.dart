// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  type: (json['type'] as num).toInt(),
  content: json['content'] as String,
  createTime: (json['createTime'] as num?)?.toInt(),
);

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'content': instance.content,
      'createTime': instance.createTime,
    };
