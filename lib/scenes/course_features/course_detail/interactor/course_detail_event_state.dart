import 'package:equatable/equatable.dart';

class CourseDetailState extends Equatable {
  final bool isLoading;
  final bool isLiked;
  final double totalAmount;
  final String courseTitle;
  final String courseDescription;
  final String instructorName;
  final String instructorAvatar;
  final String instructorBio;
  final List<String> images;

  const CourseDetailState({
    this.isLoading = false,
    this.isLiked = false,
    this.totalAmount = 5433000,
    this.courseTitle = "Quản trị vốn trong trading",
    this.courseDescription = "Mô tả khóa học bằng văn bản hiển thị và biên soạn bởi người bán. Mô tả khóa học bằng văn bản hiển thị và biên soạn bởi người bán. Mô tả khóa học bằng văn bản hiển thị và biên soạn bởi người bán.",
    this.instructorName = "TYLER BALLMER",
    this.instructorAvatar = "https://picsum.photos/200",
    this.instructorBio = "Giới thiệu giảng viên: Đây là nội dung mẫu dùng để hiển thị phần giới thiệu giảng viên. Đây là nội dung mẫu dùng để hiển thị phần giới thiệu giảng viên.",
    this.images = const [
      "https://picsum.photos/seed/course1/800/600",
      "https://picsum.photos/seed/course2/800/600",
      "https://picsum.photos/seed/course3/800/600",
    ],
  });

  CourseDetailState copyWith({
    bool? isLoading,
    bool? isLiked,
    double? totalAmount,
    String? courseTitle,
    String? courseDescription,
    String? instructorName,
    String? instructorAvatar,
    String? instructorBio,
    List<String>? images,
  }) {
    return CourseDetailState(
      isLoading: isLoading ?? this.isLoading,
      isLiked: isLiked ?? this.isLiked,
      totalAmount: totalAmount ?? this.totalAmount,
      courseTitle: courseTitle ?? this.courseTitle,
      courseDescription: courseDescription ?? this.courseDescription,
      instructorName: instructorName ?? this.instructorName,
      instructorAvatar: instructorAvatar ?? this.instructorAvatar,
      instructorBio: instructorBio ?? this.instructorBio,
      images: images ?? this.images,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isLiked,
        totalAmount,
        courseTitle,
        courseDescription,
        instructorName,
        instructorAvatar,
        instructorBio,
        images,
      ];
}
