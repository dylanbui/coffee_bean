import 'package:db_core/commons_constants.dart';

class CourseLessonModel {
  final int id;
  final int? chapterId;
  final String lessonName;
  final String? lessonVideo;
  final int? lessonDuration;
  final int? lessonTrial;
  final int? lessonSort;
  final String? createTime;
  final String? lessonDetail; // Giả định thêm field này cho phần nội dung text

  CourseLessonModel({
    required this.id,
    this.chapterId,
    required this.lessonName,
    this.lessonVideo,
    this.lessonDuration,
    this.lessonTrial,
    this.lessonSort,
    this.createTime,
    this.lessonDetail,
  });

  factory CourseLessonModel.fromJson(Dictionary json) {
    return CourseLessonModel(
      id: json['id'] as int,
      chapterId: json['chapterId'] as int?,
      lessonName: json['lessonName'] as String? ?? '',
      lessonVideo: json['lessonVideo'] as String?,
      lessonDuration: json['lessonDuration'] as int?,
      lessonTrial: json['lessonTrial'] as int?,
      lessonSort: json['lessonSort'] as int?,
      createTime: json['createTime'] as String?,
      lessonDetail: json['lessonDetail'] as String?,
    );
  }
}

class CourseLearningDetailMockData {
  static CourseLessonModel getMockLesson(int lessonId) {
    return CourseLessonModel(
      id: lessonId,
      chapterId: 1,
      lessonName: "Bài học số $lessonId: Kỹ thuật Latte Art cơ bản",
      lessonVideo: "https://www.example.com/video.mp4",
      lessonDuration: 600,
      lessonTrial: 0,
      lessonSort: 1,
      createTime: DateTime.now().toIso8601String(),
      lessonDetail: """
        <h3>Nội dung bài học</h3>
        <p>Trong bài học này, chúng ta sẽ tìm hiểu về các bước cơ bản để tạo ra một hình trái tim hoàn chỉnh trên tách Latte.</p>
        <ul>
          <li>Chuẩn bị sữa đạt chuẩn (Micro-foam).</li>
          <li>Kỹ thuật đổ sữa tạo nền.</li>
          <li>Cách ngắt dòng để tạo hình.</li>
        </ul>
        <p>Hãy xem kỹ video hướng dẫn phía trên trước khi thực hành.</p>
      """,
    );
  }
}
