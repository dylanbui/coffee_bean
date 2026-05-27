import 'package:coffee_bean/data/repository/comment_repository.dart';
import 'package:coffee_bean/scenes/comment_list/comment_list_router.dart';
import 'package:coffee_bean/scenes/comment_list/interactor/comment_list_event_state.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/utils/locator.dart';

class CommentListInteractor extends CubitInteractor<CommentListRoutable, CommentListState> {
  final CommentRepository _commentRepository = locator<CommentRepository>();
  final int _limit = 10;

  CommentListInteractor(CommentListRoutable router, int productId, String type)
      : super(CommentListState(productId: productId, type: type), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    loadComments();
  }

  Future<void> loadComments() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    try {
      final comments = await _commentRepository.getComments(
        productId: state.productId,
        type: state.type,
        offset: 0,
        limit: _limit,
      );
      emit(state.copyWith(
        comments: comments,
        isLoading: false,
        hasMore: comments.length >= _limit,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadMore || !state.hasMore) return;
    emit(state.copyWith(isLoadMore: true));

    try {
      final moreComments = await _commentRepository.getComments(
        productId: state.productId,
        type: state.type,
        offset: state.comments.length,
        limit: _limit,
      );
      
      final updatedComments = List<TblComment>.from(state.comments)..addAll(moreComments);
      
      emit(state.copyWith(
        comments: updatedComments,
        isLoadMore: false,
        hasMore: moreComments.length >= _limit,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadMore: false));
    }
  }

  void goBack() {
    router?.pop();
  }
}
