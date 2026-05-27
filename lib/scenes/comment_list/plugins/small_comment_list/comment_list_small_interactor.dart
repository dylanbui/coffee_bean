import 'package:coffee_bean/data/repository/comment_repository.dart';
import 'package:coffee_bean/scenes/comment_list/comment_list_router.dart';
import 'package:coffee_bean/scenes/comment_list/plugins/small_comment_list/comment_list_small_event_state.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/utils/locator.dart';

class CommentListSmallInteractor extends CubitInteractor<CommentListRoutable, CommentListSmallState> {
  final CommentRepository _commentRepository = locator<CommentRepository>();
  final int limitComments;
  final int productId;
  final String type;

  CommentListSmallInteractor(CommentListRoutable router, {required this.productId, required this.type, required this.limitComments})
      : super(CommentListSmallState(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    loadRecentComments();
  }

  Future<void> loadRecentComments() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    try {
      final comments = await _commentRepository.getComments(
        productId: productId,
        type: type,
        limit: limitComments,
      );
      emit(state.copyWith(
        comments: comments,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void onViewAll() {
    router?.onViewAllComments(productId, type);
  }
}
