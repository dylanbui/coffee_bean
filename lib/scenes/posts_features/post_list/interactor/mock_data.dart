import 'package:coffee_bean/data/model/response/hub/post.dart';

class PostListMockData {
  static List<Post> get mockPosts => List.generate(30, (index) => Post(
    id: index + 100,
    postTitle: 'Bài viết tìm kiếm số ${index + 1}: Chia sẻ kinh nghiệm pha cà phê tại nhà',
    postDesc: 'Đây là mô tả ngắn cho bài viết về cà phê số ${index + 1}. Một ly cà phê ngon bắt đầu từ khâu chọn hạt và kỹ thuật rang xay đúng chuẩn...',
    postContent: 'Nội dung chi tiết của bài viết số ${index + 1} về nghệ thuật pha chế và thưởng thức cà phê tại nhà theo phong cách hiện đại...',
    postImgs: ['https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=400&auto=format&fit=crop'],
    userNickname: 'Người pha chế ${index + 1}',
    userAvatar: 'https://i.pravatar.cc/100?u=post_search_$index',
    topicTags: ['Coffee', 'HomeBrew', 'Barista'],
    postCommentCount: (index + 1) * 5,
    postLikeCount: (index + 1) * 10,
    shareCount: (index + 1) * 2,
    viewCount: (index + 1) * 12,
    createTime: '23/04/2026',
  ));
}
