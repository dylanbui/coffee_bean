import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:coffee_bean/data/model/response/hub/topic_detail.dart';

class PostByTopicMockData {
  static TopicDetail getMockTopic(int id) {
    return TopicDetail(
      id: id,
      topicName: "Tên chủ đề Tên chủ đề#",
      topicIcon: "https://images.unsplash.com/photo-1511920170033-f8396924c348?q=80&w=1000&auto=format&fit=crop",
      topicDesc: "Mô tả cho chủ đề này giúp người dùng hiểu hơn về nội dung",
      topicPostCount: 2048,
      topicViewCount: 114000,
      topicLikeCount: 5600,
      topicCommentCount: 1200,
    );
  }

  static List<Post> getMockPosts() {
    return List.generate(
      10,
      (index) => Post(
        id: index,
        userNickname: "Lorem ipsum",
        userAvatar: "https://i.pravatar.cc/150?u=$index",
        postTitle: "KHÓA HỌC QUẢN TRỊ TÀI SẢN TRONG GIAO DỊCH",
        postImgs: [
          "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=1000&auto=format&fit=crop",
        ],
        viewCount: 1200,
        postLikeCount: 600,
        postCommentCount: 300,
        createTime: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
