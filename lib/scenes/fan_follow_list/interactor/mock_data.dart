import 'package:coffee_bean/data/models/response/hub/follower_user.dart';

class FanFollowMockData {
  static List<FollowUser> getFollowers() {
    return [
      FollowUser(
        id: 1,
        userId: 101,
        expertTitle: "Trần Văn A",
        expertDesc: "Yêu thích cà phê Arabica và các loại hạt rang xay.",
        expertAvatar: "https://i.pravatar.cc/150?u=101",
      ),
      FollowUser(
        id: 2,
        userId: 102,
        expertTitle: "Nguyễn Thị B",
        expertDesc: "Chuyên gia nếm thử cà phê tại TPHCM.",
        expertAvatar: "https://i.pravatar.cc/150?u=102",
      ),
      FollowUser(
        id: 3,
        userId: 103,
        expertTitle: "Lê Văn C",
        expertDesc: "Chia sẻ kiến thức về rang xay cà phê thủ công.",
        expertAvatar: "https://i.pravatar.cc/150?u=103",
      ),
    ];
  }

  static List<FollowUser> getFollowing() {
    return [
      FollowUser(
        id: 4,
        userId: 201,
        expertTitle: "Phạm Văn D",
        expertDesc: "Nông dân trồng cà phê tại Đắk Lắk.",
        expertAvatar: "https://i.pravatar.cc/150?u=201",
      ),
      FollowUser(
        id: 5,
        userId: 202,
        expertTitle: "Hoàng Thị E",
        expertDesc: "Chủ quán cà phê Speciality.",
        expertAvatar: "https://i.pravatar.cc/150?u=202",
      ),
    ];
  }
}
