import 'package:coffee_bean/data/model/response/hub/course_info.dart';
import 'package:coffee_bean/scenes/course_features/instructor_profile/models/instructor_profile_model.dart';
import 'package:coffee_bean/scenes/course_features/instructor_profile/models/instructor_post_model.dart';

class InstructorMockData {
  static InstructorProfileModel get mockInstructor => InstructorProfileModel(
        id: 1,
        name: "Tyler Ballmer invest",
        avatar: "https://i.pravatar.cc/150?u=tyler",
        title: "Chuyên gia",
        postCount: 75,
        followerCount: 10300,
        followingCount: 5,
        isFollowed: true,
        bio: """
<p>Nội dung giới thiệu cá nhân hiển thị mẫu, nội dung giới thiệu cá nhân hiển thị mẫu, nội dung giới thiệu cá nhân hiển thị mẫu, nội dung giới thiệu.</p>
<p>Đây là nội dung demo hỗ trợ hiển thị <b>HTML</b> để người dùng có thể xem được tiểu sử chi tiết của chuyên gia.</p>
""",
        coverImages: [
          "https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&w=800&q=80",
          "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=800&q=80",
          "https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&w=800&q=80",
          "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=800&q=80",
        ],
      );

  static List<InstructorPostModel> get mockPosts => List.generate(
        20,
        (index) => InstructorPostModel(
          id: index,
          title: "$index - KHÓA HỌC QUẢN TRỊ TÀI SẢN TRONG GIAO DỊCH",
          coverImage: "https://images.unsplash.com/photo-1591115765373-5207764f72e7?auto=format&fit=crop&w=400&q=80",
          viewCount: 600 + index,
          authorName: "Lorem ipsum",
          isVideo: true,
        ),
      );

  static List<CourseInfo> get mockCourses => List.generate(
        25,
        (index) => CourseInfo(
          id: index,
          courseName: "$index - Khóa học quản trị vốn trong đầu tư tài chính 4.0",
          courseCover: "https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&w=400&q=80",
          coursePrice: index % 2 == 0 ? 999000 : 0,
          courseDesc: "Khóa học quản trị vốn trong đầu tư tài chính...",
        ),
      );
}
