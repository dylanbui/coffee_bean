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
  final int type;

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

    final res = await _commentRepository.getCommentPage(
      spuId: productId,
      type: type,
      pageNo: 1,
      pageSize: limitComments,
    );

    final result = res.toResult();
    if (result case DbSuccess(:final data)) {
      emit(state.copyWith(
        comments: data.list,
        isLoading: false,
      ));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  void onViewAll() {
    controller.listener?.onNavigateToAllComments(productId, type);
  }
}
