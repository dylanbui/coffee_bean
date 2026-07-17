import 'package:coffee_bean/data/repository/comment_repository.dart';
import 'package:coffee_bean/scenes/comment_list/comment_list_router.dart';
import 'package:coffee_bean/scenes/comment_list/interactor/comment_list_event_state.dart';
import 'package:coffee_bean/scenes/comment_list/comment_constant.dart';
import 'package:db_core/db_core.dart';

class CommentListInteractor extends CubitInteractor<CommentListRoutable, CommentListState> {
  late final ICommentRepository _repository;

  CommentListInteractor(
    CommentListRoutable router, 
    int resourceId, 
    CommentSource source, 
    int type, 
    {int pageSize = 10}
  ) : super(CommentListState(resourceId: resourceId, source: source, type: type, pageSize: pageSize), router: router) {
    _repository = locator<CommentRepository>().getSource(source);
  }

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    loadComments();
  }

  Future<void> loadComments() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, pageNo: 1));

    final result = await _repository.getCommentPage(
      resourceId: state.resourceId,
      type: state.type,
      pageNo: 1,
      pageSize: state.pageSize,
    );

    if (result case DbSuccess(:final data)) {
      final comments = data.list;
      emit(state.copyWith(
        comments: comments,
        isLoading: false,
        hasMore: data.list.length >= state.pageSize,
        pageNo: 1,
      ));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadMore || !state.hasMore) return;
    
    final nextPage = state.pageNo + 1;
    emit(state.copyWith(isLoadMore: true));

    final result = await _repository.getCommentPage(
      resourceId: state.resourceId,
      type: state.type,
      pageNo: nextPage,
      pageSize: state.pageSize,
    );

    if (result case DbSuccess(:final data)) {
      final moreComments = data.list;
      final updatedComments = List<IComment>.from(state.comments)..addAll(moreComments);
      
      emit(state.copyWith(
        comments: updatedComments,
        isLoadMore: false,
        hasMore: moreComments.length >= state.pageSize,
        pageNo: nextPage,
      ));
    } else {
      emit(state.copyWith(isLoadMore: false));
    }
  }

  void onViewAll() {
    router?.onViewAllComments(state.resourceId, state.type);
  }

  void goBack() {
    router?.pop();
  }
}
