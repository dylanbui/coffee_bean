import 'dart:async';
import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:coffee_bean/scenes/post_detail/interactor/post_detail_event_state.dart';
import 'package:coffee_bean/scenes/post_detail/post_detail_builder.dart';
import 'package:db_core/db_core.dart';

class PostDetailInteractor extends CubitInteractor<PostDetailRoutable, PostDetailState> implements CommentListSmallListener {
  final int postId;
  
  // Khởi tạo Controller tại đây để giữ vòng đời bền vững
  final commentController = CommentListSmallController();

  PostDetailInteractor(PostDetailRoutable router, {required this.postId})
      : super(PostDetailState(isLoading: true), router: router) {
    // Đăng ký listener ngay khi khởi tạo
    commentController.listener = this;
  }

  @override
  void onDidBecomeActive() {
    fetchPostDetail();
  }

  Future<void> fetchPostDetail() async {
    emit(state.copyWith(isLoading: true));
    
    // Simulate API call with fake data
    await Future.delayed(const Duration(seconds: 1));
    
    final fakePost = PostModel(
      id: postId,
      title: "Tiêu đề bài viết Tiêu đề bài viết Tiêu đề bài viết Tiêu đề bài viết Tiêu đề bài viết",
      authorName: "Tyler Ballmer invest",
      authorAvatar: "https://i.pravatar.cc/150?u=$postId",
      date: "22/02/2026",
      isFollowing: false,
      hashtags: ["#jbhsdkjbdj", "#hagtag"],
      images: [
        "https://picsum.photos/id/10/800/400",
        "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
        "https://picsum.photos/id/20/800/400",
        "https://picsum.photos/id/30/800/400",
      ],
      contentHtml: """
        <p>Đây là nội dung mẫu để điền. Đây là nội dung mẫu để điền. Đây là nội dung mẫu để điền. Đây là nội dung mẫu để điền. Đây là nội dung mẫu để điền. Đây là nội dung mẫu để điền. Đây là nội dung mẫu để điền. Đây là nội dung mẫu để điền. Đây là nội dung mẫu để điền. Đây là nội dung mẫu để điền. Đây là nội dung mẫu để điền. Đây là nội dung mẫu để điền.</p>
        <h3>1. Phân tích thị trường</h3>
        <p>Thị trường tài chính hiện nay đang chứng kiến những biến động mạnh mẽ do các yếu tố vĩ mô tác động. Việc hiểu rõ xu hướng là chìa khóa để thành công trong giao dịch. Các nhà đầu tư cần chú ý đến các chỉ số kinh tế quan trọng như CPI, lãi suất của Fed và các báo cáo việc làm.</p>
        <img src="https://picsum.photos/id/48/800/400" alt="Market analysis" />
        <h3>2. Chiến lược đầu tư dài hạn</h3>
        <p>Đầu tư giá trị luôn là một lựa chọn an toàn cho những ai muốn tích lũy tài sản bền vững. Thay vì chạy theo những cơn sóng ngắn hạn, hãy tập trung vào nội tại của doanh nghiệp và tiềm năng tăng trưởng trong 5-10 năm tới.</p>
        <ul>
          <li>Tìm kiếm các doanh nghiệp có lợi thế cạnh tranh bền vững.</li>
          <li>Đánh giá năng lực của ban lãnh đạo.</li>
          <li>Kiểm soát rủi ro bằng cách đa dạng hóa danh mục đầu tư.</li>
          <li>Luôn giữ một phần tiền mặt để tận dụng cơ hội khi thị trường điều chỉnh sâu.</li>
        </ul>
        <p>Bên cạnh đó, việc duy trì tâm lý ổn định là vô cùng quan trọng. Đừng để nỗi sợ hãi (FEAR) hay lòng tham (GREED) chi phối các quyết định của bạn. Hãy lập một kế hoạch giao dịch chi tiết và tuân thủ nó một cách kỷ luật.</p>
        <h3>3. Kết luận</h3>
        <p>Tóm lại, thành công trong đầu tư không đến từ sự may mắn mà đến từ sự chuẩn bị kỹ lưỡng và kiến thức chuyên sâu. Hy vọng bài viết này mang lại những thông tin hữu ích cho các bạn trên con đường chinh phục thị trường tài chính.</p>
        <p>Tiếp tục nội dung bài viết để kiểm tra khả năng scroll và hiển thị HTML của ứng dụng. Nội dung này được tạo ra dài hơn để đảm bảo giao diện có thể scroll mượt mà và người dùng có thể trải nghiệm toàn bộ các thành phần của bài viết.</p>
        <p>Cảm ơn các bạn đã theo dõi bài viết này. Hãy để lại bình luận phía dưới nếu bạn có bất kỳ câu hỏi nào!</p>
      """,
      readCount: 13000,
      commentCount: 2473,
      likeCount: 8756,
      isLiked: false,
      isSaved: false,
    );
    
    emit(state.copyWith(isLoading: false, post: fakePost));
  }

  void toggleFollow() {
    if (state.post == null) return;
    final newPost = state.post!.copyWith(isFollowing: !state.post!.isFollowing);
    emit(state.copyWith(post: newPost));
  }

  void toggleLike() {
    if (state.post == null) return;
    final isLiked = !state.post!.isLiked;
    final newLikeCount = isLiked ? state.post!.likeCount + 1 : state.post!.likeCount - 1;
    final newPost = state.post!.copyWith(isLiked: isLiked, likeCount: newLikeCount);
    emit(state.copyWith(post: newPost));
  }

  void toggleSave() {
    if (state.post == null) return;
    final newPost = state.post!.copyWith(isSaved: !state.post!.isSaved);
    emit(state.copyWith(post: newPost));
  }

  void sharePost() {
    // Implement share logic
  }

  void reportPost() {
    router?.openProblemReport();
  }

  @override
  void onNavigateToAllComments(int productId, int type) {
    // Navigate to full comment list if needed
    // router?.gotoCommentList(productId, type);
  }
}
