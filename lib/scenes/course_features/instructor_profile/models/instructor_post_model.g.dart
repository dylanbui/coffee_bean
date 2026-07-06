// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructorPostModel _$InstructorPostModelFromJson(Map<String, dynamic> json) =>
    InstructorPostModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      coverImage: json['coverImage'] as String?,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      authorName: json['authorName'] as String?,
      authorAvatar: json['authorAvatar'] as String?,
      isVideo: json['isVideo'] as bool? ?? false,
    );

Map<String, dynamic> _$InstructorPostModelToJson(
  InstructorPostModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'coverImage': instance.coverImage,
  'viewCount': instance.viewCount,
  'authorName': instance.authorName,
  'authorAvatar': instance.authorAvatar,
  'isVideo': instance.isVideo,
};
