// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseTypeItem _$CourseTypeItemFromJson(Map<String, dynamic> json) =>
    CourseTypeItem(
      id: (json['id'] as num).toInt(),
      label: json['label'] as String,
    );

Map<String, dynamic> _$CourseTypeItemToJson(CourseTypeItem instance) =>
    <String, dynamic>{'id': instance.id, 'label': instance.label};

CourseInfo _$CourseInfoFromJson(Map<String, dynamic> json) => CourseInfo(
  id: (json['id'] as num).toInt(),
  courseName: json['courseName'] as String? ?? '',
  courseCover: json['courseCover'] as String? ?? '',
  courseDesc: json['courseDesc'] as String?,
  courseDetail: json['courseDetail'] as String?,
  instructorId: (json['instructorId'] as num?)?.toInt(),
  coursePrice: (json['coursePrice'] as num?)?.toDouble() ?? 0.0,
  courseOrigPrice: (json['courseOrigPrice'] as num?)?.toDouble(),
  courseLessons: (json['courseLessons'] as num?)?.toInt(),
  courseLevel: (json['courseLevel'] as num?)?.toInt(),
  courseDuration: (json['courseDuration'] as num?)?.toInt(),
  courseType: (json['courseType'] as num?)?.toInt(),
  courseTypeArray: (json['courseTypeArray'] as List<dynamic>?)
      ?.map((e) => CourseTypeItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CourseInfoToJson(CourseInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseName': instance.courseName,
      'courseCover': instance.courseCover,
      'courseDesc': instance.courseDesc,
      'courseDetail': instance.courseDetail,
      'instructorId': instance.instructorId,
      'coursePrice': instance.coursePrice,
      'courseOrigPrice': instance.courseOrigPrice,
      'courseLessons': instance.courseLessons,
      'courseLevel': instance.courseLevel,
      'courseDuration': instance.courseDuration,
      'courseType': instance.courseType,
      'courseTypeArray': instance.courseTypeArray,
    };
