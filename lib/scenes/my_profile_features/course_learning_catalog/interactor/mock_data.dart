import 'package:coffee_bean/data/model/response/hub/course_info_detail.dart';
import 'package:coffee_bean/data/model/response/hub/instructor_info.dart';

class LessonModel {
  final int id;
  final String title;
  final bool isNew;
  final bool isCompleted;

  LessonModel({
    required this.id,
    required this.title,
    this.isNew = false,
    this.isCompleted = false,
  });
}

class CourseCatalogMockData {
  static CourseInfoDetail getMockCourseDetail(int courseId) {
    return CourseInfoDetail(
      id: courseId,
      courseName: "Khóa học pha chế chuyên sâu #$courseId",
      courseCover: ["https://picsum.photos/400/300?random=$courseId"],
      courseDesc: "Hướng dẫn kỹ thuật Latte Art và quản lý quầy bar chuyên nghiệp.",
      courseDetail: "<h3>Giới thiệu khóa học</h3><p>Khóa học này cung cấp các kiến thức từ cơ bản đến nâng cao về nghệ thuật pha chế cà phê, tập trung vào kỹ thuật tạo hình Latte Art và quy trình vận hành quầy bar tối ưu.</p>",
      instructorId: 101,
      coursePrice: 599000,
      courseOrigPrice: 899000,
      courseLessons: 12,
      courseLevel: 1,
      courseDuration: 3600 * 5,
      courseType: 1,
    );
  }

  static InstructorInfo getMockInstructor(int instructorId) {
    return InstructorInfo(
      id: instructorId,
      instructorName: "Nguyễn Văn A",
      instructorAvatar: "https://i.pravatar.cc/150?u=$instructorId",
      instructorTitle: "Chuyên gia pha chế",
      instructorDesc: "Hơn 10 năm kinh nghiệm trong ngành F&B, đã đào tạo hàng ngàn học viên về kỹ thuật Barista.",
    );
  }

  static List<LessonModel> getMockLessons() {
    return List.generate(
      12,
      (index) => LessonModel(
        id: index + 1,
        title: "Bài ${index + 1}: Kỹ thuật pha chế nâng cao phần ${index + 1}",
        isNew: index > 3,
        isCompleted: index < 3,
      ),
    );
  }
}
