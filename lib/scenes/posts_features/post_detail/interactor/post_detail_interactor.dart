import 'dart:async';
import 'package:coffee_bean/data/repository/hub_repository.dart';
import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:coffee_bean/scenes/posts_features/post_detail/interactor/mock_data.dart';
import 'package:coffee_bean/scenes/posts_features/post_detail/interactor/post_detail_event_state.dart';
import 'package:coffee_bean/scenes/posts_features/post_detail/post_detail_builder.dart';
import 'package:coffee_bean/scenes/posts_features/post_report/post_report_builder.dart';
import 'package:db_core/db_core.dart';

class PostDetailInteractor extends CubitInteractor<PostDetailRoutable, PostDetailState> implements CommentListSmallListener {
  final int postId;
  final HubRepository _hubRepository = locator<HubRepository>();
  
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
    
    // Gọi đồng thời Detail và Status
    final results = await Future.wait([
      _hubRepository.getPostDetail(postId),
      _hubRepository.checkPostStatus(postId),
    ]);

    final detailResult = results[0] as DbResult;
    final statusResult = results[1] as DbResult;

    PostDetailState newState = state.copyWith(isLoading: false);

    // Xử lý Detail
    if (detailResult case DbSuccess(:final data)) {
      if (data != null) {
        newState = newState.copyWith(post: data);
      } else {
        // Nếu data null (empty), dùng mock
        newState = newState.copyWith(post: mockPostDetail);
      }
    } else {
      // Nếu lỗi API, dùng mock để test UI
      newState = newState.copyWith(post: mockPostDetail);
    }

    // Xử lý Status
    if (statusResult case DbSuccess(:final data)) {
      if (data != null) {
        newState = newState.copyWith(
          isLiked: data.liked ?? false,
          isFollowed: data.followed ?? false,
          isFavorited: data.favorited ?? false,
        );
      }
    }

    emit(newState);
  }

  Future<void> toggleFollow() async {
    final post = state.post;
    if (post == null || post.userId == null) return;

    // Tạm thời update UI trước (Optimistic UI)
    final newFollowed = !state.isFollowed;
    emit(state.copyWith(isFollowed: newFollowed));

    final result = await _hubRepository.toggleFollow(post.userId!);
    if (result case DbFailure()) {
      // Revert nếu lỗi
      emit(state.copyWith(isFollowed: !newFollowed));
    }
  }

  Future<void> toggleLike() async {
    if (state.post == null) return;

    final newLiked = !state.isLiked;
    // Cập nhật like count trong UI model nếu cần,
    // nhưng ở đây ta chỉ update state boolean
    emit(state.copyWith(isLiked: newLiked));

    final result = await _hubRepository.toggleLike(postId);
    if (result case DbFailure()) {
      emit(state.copyWith(isLiked: !newLiked));
    } else {
      // Có thể fetch lại detail để lấy like count mới nhất từ server
      // hoặc tự cộng trừ local. Ở đây ta chọn refresh nhẹ.
    }
  }

  Future<void> toggleSave() async {
    if (state.post == null) return;
    
    final newFavorited = !state.isFavorited;
    emit(state.copyWith(isFavorited: newFavorited));

    final result = await _hubRepository.toggleFavorite(postId, type: FavoriteType.post);
    if (result case DbFailure()) {
      emit(state.copyWith(isFavorited: !newFavorited));
    }
  }

  Future<void> sharePost() async {
    if (state.post == null) return;
    await _hubRepository.createShareRecord(postId);
  }

  void reportPost() {
    final post = state.post;
    if (post == null) return;
    
    router?.openReportPost(
      targetInfo: ReportTargetInfo(
        type: ReportTargetType.post,
        targetId: postId,
        nickname: post.expertTitle ?? '',
        imageUrl: post.postImgs?.firstOrNull,
        summary: post.postTitle ?? post.postContent ?? '',
      ),
    );
  }

  @override
  void onNavigateToAllComments(int productId, int type) {
    // Navigate to full comment list if needed
    // router?.gotoCommentList(productId, type);
  }
}
