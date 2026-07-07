import 'package:coffee_bean/data/model/response/hub/course_info.dart';

class CourseLearningProgressModel {
  final CourseInfo course;
  final int completedLessons;

  CourseLearningProgressModel({
    required this.course,
    required this.completedLessons,
  });
}

class CourseLearningMockData {
  static List<CourseLearningProgressModel> getItems() {
    return List.generate(15, (index) => CourseLearningProgressModel(
      course: CourseInfo(
        id: index,
        courseName: "Khóa học pha chế chuyên sâu #${index + 1}",
        courseDesc: "Hướng dẫn kỹ thuật Latte Art và quản lý quầy bar chuyên nghiệp.",
        courseCover: "https://picsum.photos/200/150?random=$index",
        courseLessons: 12,
      ),
      completedLessons: (index + 1) * 2,
    ));
  }
}
