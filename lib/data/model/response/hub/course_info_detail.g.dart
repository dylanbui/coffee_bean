// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_info_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseInfoDetail _$CourseInfoDetailFromJson(Map<String, dynamic> json) =>
    CourseInfoDetail(
      id: (json['id'] as num).toInt(),
      courseName: json['courseName'] as String,
      courseCover: const SmartListStringConverter().fromJson(
        json['courseCover'],
      ),
      courseDesc: json['courseDesc'] as String?,
      courseDetail: json['courseDetail'] as String?,
      instructorId: (json['instructorId'] as num?)?.toInt(),
      coursePrice: (json['coursePrice'] as num?)?.toDouble(),
      courseOrigPrice: (json['courseOrigPrice'] as num?)?.toDouble(),
      courseLessons: (json['courseLessons'] as num?)?.toInt(),
      courseLevel: (json['courseLevel'] as num?)?.toInt(),
      courseDuration: (json['courseDuration'] as num?)?.toInt(),
      courseType: (json['courseType'] as num?)?.toInt(),
      courseTypeArray: (json['courseTypeArray'] as List<dynamic>?)
          ?.map((e) => CourseTypeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseInfoDetailToJson(
  CourseInfoDetail instance,
) => <String, dynamic>{
  'id': instance.id,
  'courseName': instance.courseName,
  'courseCover': const SmartListStringConverter().toJson(instance.courseCover),
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
