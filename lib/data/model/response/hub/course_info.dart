import 'package:db_core/commons_constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'course_info.g.dart';

@JsonSerializable()
class CourseTypeItem {
  final int id;
  final String label;

  CourseTypeItem({
    required this.id,
    required this.label,
  });

  factory CourseTypeItem.fromJson(Dictionary json) => _$CourseTypeItemFromJson(json);
  Dictionary toJson() => _$CourseTypeItemToJson(this);
}

@JsonSerializable()
class CourseInfo {
  final int id;
  final String courseName;
  final String? courseCover;
  
  final String? courseDesc;
  final String? courseDetail;
  final int? instructorId;
  final double coursePrice;
  final double? courseOrigPrice;
  final int? courseLessons;
  final int? courseLevel;
  final int? courseDuration;
  final int? courseType;
  final List<CourseTypeItem>? courseTypeArray;

  CourseInfo({
    required this.id,
    this.courseName = '',
    this.courseCover = '',
    this.courseDesc,
    this.courseDetail,
    this.instructorId,
    this.coursePrice = 0.0,
    this.courseOrigPrice,
    this.courseLessons,
    this.courseLevel,
    this.courseDuration,
    this.courseType,
    this.courseTypeArray,
  });

  factory CourseInfo.fromJson(Dictionary json) => _$CourseInfoFromJson(json);
  Dictionary toJson() => _$CourseInfoToJson(this);

  String get mainImage => courseCover ?? "";
}
