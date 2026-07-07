import 'package:coffee_bean/data/model/json_converters.dart';
import 'package:coffee_bean/data/model/response/hub/course_info.dart';
import 'package:db_core/commons_constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'course_info_detail.g.dart';

@JsonSerializable()
class CourseInfoDetail {
  final int id;
  final String courseName;
  
  @SmartListStringConverter()
  final List<String> courseCover;

  final String? courseDesc;
  final String? courseDetail;
  final int? instructorId;
  final double? coursePrice;
  final double? courseOrigPrice;
  final int? courseLessons;
  final int? courseLevel;
  final int? courseDuration;
  final int? courseType;
  final List<CourseTypeItem>? courseTypeArray;

  CourseInfoDetail({
    required this.id,
    required this.courseName,
    required this.courseCover,
    this.courseDesc,
    this.courseDetail,
    this.instructorId,
    this.coursePrice,
    this.courseOrigPrice,
    this.courseLessons,
    this.courseLevel,
    this.courseDuration,
    this.courseType,
    this.courseTypeArray,
  });

  factory CourseInfoDetail.fromJson(Dictionary json) => _$CourseInfoDetailFromJson(json);
  Dictionary toJson() => _$CourseInfoDetailToJson(this);
}
