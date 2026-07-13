import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';
import 'package:coffee_bean/data/model/response/hub/post.dart';

class CommunityMockData {
  static List<String> get mockBanners => [
    'https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=1080&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=1080&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=1080&auto=format&fit=crop',
  ];

  static List<HotTopic> get mockHotTopics => List.generate(10, (index) => HotTopic(
    id: index + 1,
    topicName: 'Chủ đề thịnh hành ${index + 1}',
    topicIcon: 'https://i.pravatar.cc/100?u=${index + 1}',
  ));

  static List<Post> getPostsByScene(String scene) {
    String titlePrefix = "";
    String imageUrl = "";
    if (scene == 'FOLLOWING') {
      titlePrefix = "Gợi ý: ";
      imageUrl = 'https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=400&auto=format&fit=crop';
    } else if (scene == 'RECOMMEND') {
      titlePrefix = "Đề xuất: ";
      imageUrl = 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=400&auto=format&fit=crop';
    } else {
      titlePrefix = "Thịnh hành: ";
      imageUrl = 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=400&auto=format&fit=crop';
    }

    return List.generate(10, (index) => Post(
      id: index + 1,
      postTitle: '$titlePrefix KHÓA HỌC QUẢN TRỊ TÀI SẢN TRONG GIAO DỊCH',
      postImgs: [imageUrl],
      userNickname: 'Lorem ipsum',
      userAvatar: 'https://i.pravatar.cc/100?u=user_${scene}_$index',
      postCommentCount: (index + 1) * 100,
      viewCount: (index + 1) * 200,
    ));
  }
}
