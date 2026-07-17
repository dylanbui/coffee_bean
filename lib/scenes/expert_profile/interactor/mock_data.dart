import 'package:coffee_bean/data/model/response/hub/expert_info.dart';
import 'package:coffee_bean/data/model/response/hub/user_stat.dart';
import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:coffee_bean/data/model/response/hub/course_info.dart';

class ExpertProfileMockData {
  static ExpertInfo get mockExpertInfo => ExpertInfo(
        id: 1,
        userNickname: "Chuyên gia Cà phê TMLab",
        userAvatar: "https://i.pravatar.cc/150?u=expert1",
        expertTitle: "Influencer",
        expertIntro: "Chào mừng bạn đến với thế giới cà phê đặc sản. Tôi có 10 năm kinh nghiệm trong ngành Rang và Pha chế. Hy vọng những chia sẻ của tôi sẽ giúp bạn tìm thấy niềm vui trong mỗi tách cà phê. Nội dung giới thiệu cá nhân hiển thị mẫu, nội dung giới thiệu cá nhân hiển thị mẫu, nội dung giới thiệu cá nhân hiển thị mẫu, nội dung giới thiệu.",
        expertStatus: 1,
      );

  static UserStat get mockUserStat => UserStat(
        statFansCount: 722,
        statFollowCount: 12,
        statPostCount: 45,
        statIsExpert: true,
      );

  static List<Post> get mockPosts => List.generate(
        6,
        (index) => Post(
          id: index,
          postTitle: "Kỹ thuật pha Pour-over cơ bản cho người mới bắt đầu bài $index",
          postImgs: ["https://picsum.photos/400/500?random=$index"],
          postCommentCount: 659 + index,
          userNickname: "Chuyên gia Cà phê TMLab",
          userAvatar: "https://i.pravatar.cc/150?u=expert1",
        ),
      );

  static List<CourseInfo> get mockCourses => [
        CourseInfo(
          id: 1,
          courseName: "Nghệ thuật Rang cà phê hiện đại",
          courseCover: "https://picsum.photos/400/300?random=10",
          coursePrice: 1500000,
          courseLessons: 12,
        ),
        CourseInfo(
          id: 2,
          courseName: "Barista Skills: Từ cơ bản đến nâng cao",
          courseCover: "https://picsum.photos/400/300?random=11",
          coursePrice: 2000000,
          courseLessons: 15,
        ),
      ];
}
