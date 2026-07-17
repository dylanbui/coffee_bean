import 'package:coffee_bean/data/repository/comment_repository.dart';
import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:coffee_bean/scenes/comment_list/comment_list_router.dart';
import 'package:coffee_bean/scenes/comment_list/plugins/small_comment_list/comment_list_small_event_state.dart';
import 'package:coffee_bean/scenes/comment_list/comment_constant.dart';
import 'package:db_core/db_core.dart';

class CommentListSmallInteractor extends CubitInteractor<CommentListRoutable, CommentListSmallState> {
  final CommentListSmallController controller;
  late final ICommentRepository _repository;
  final int limitComments;
  final int resourceId;
  final CommentSource source;
  final int type;

  CommentListSmallInteractor(
    CommentListRoutable router, {
    required this.resourceId,
    required this.source,
    required this.type,
    required this.limitComments,
    required this.controller,
  }) : super(CommentListSmallState(), router: router) {
    _repository = locator<CommentRepository>().getSource(source);
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

    final result = await _repository.getCommentPage(
      resourceId: resourceId,
      type: type,
      pageNo: 1,
      pageSize: limitComments,
    );

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
    controller.listener?.onNavigateToAllComments(resourceId, type);
  }
}
