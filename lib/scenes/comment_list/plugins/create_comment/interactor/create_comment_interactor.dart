import 'package:coffee_bean/data/repository/comment_repository.dart';
import 'package:coffee_bean/scenes/comment_list/comment_constant.dart';
import 'package:coffee_bean/scenes/comment_list/plugins/create_comment/interactor/create_comment_event_state.dart';
import 'package:db_core/db_core.dart';

abstract interface class CreateCommentListener {
  void onCommentCreatedSuccess();
}

class CreateCommentInteractor extends CubitInteractor<DbNoteRoutable, CreateCommentState> {
  final int resourceId;
  final CommentSource source;
  final CreateCommentListener? listener;
  final bool autoFocus;
  final CommentRepository _commentRepository = locator.get<CommentRepository>();

  CreateCommentInteractor({
    required this.resourceId,
    required this.source,
    this.listener,
    this.autoFocus = false,
  }) : super(CreateCommentState());

  void onContentChanged(String content) {
    emit(state.copyWith(content: content, clearFailure: true));
  }

  Future<void> sendComment() async {
    final content = state.content.trim();
    if (content.isEmpty) return;

    // Chỉ lấy tối đa 500 ký tự khi gửi lên server
    final truncatedContent = content.length > 500 ? content.substring(0, 500) : content;

    emit(state.copyWith(isSending: true, clearFailure: true));

    final result = await _commentRepository.getSource(source).createComment(
      resourceId: resourceId,
      content: truncatedContent,
    );

    if (result case DbSuccess()) {
      emit(state.copyWith(isSending: false, content: ''));
      listener?.onCommentCreatedSuccess();
    } else if (result case DbFailure()) {
      emit(state.copyWith(isSending: false, failure: result));
    }
  }
}
