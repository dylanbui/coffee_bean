import 'package:coffee_bean/data/repository/comment_repository.dart';
import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:coffee_bean/scenes/comment_list/comment_list_router.dart';
import 'package:coffee_bean/scenes/comment_list/plugins/small_comment_list/comment_list_small_event_state.dart';
import 'package:db_core/db_core.dart';

class CommentListSmallInteractor extends CubitInteractor<CommentListRoutable, CommentListSmallState> {
  final CommentListSmallController controller;
  final CommentRepository _commentRepository = locator<CommentRepository>();
  final int limitComments;
  final int productId;
  final String type;

  CommentListSmallInteractor(
    CommentListRoutable router, {
    required this.productId,
    required this.type,
    required this.limitComments,
    required this.controller,
  }) : super(CommentListSmallState(), router: router) {
    controller.attach(this);
  }

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    loadRecentComments();
  }

  Future<void> loadRecentComments() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    try {
      final comments = await _commentRepository.getComments(productId: productId, type: type, limit: limitComments);
      emit(state.copyWith(comments: comments, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void onViewAll() {
    print("DEBUG: CommentListSmallInteractor.onViewAll clicked");
    if (controller.listener == null) {
      print("DEBUG: ERROR - controller.listener is NULL!");
    }
    controller.listener?.onNavigateToAllComments(productId, type);
  }
}
