import 'package:db_core/architecture_ribs/note_router.dart';

class ViewAllCommentRoute implements DbNoteRoute {
  final int productId;
  final int type;
  ViewAllCommentRoute(this.productId, this.type);
}

abstract class CommentListRoutable implements DbNoteRoutable {
  void onViewAllComments(int productId, int type);
}

class CommentListRouter extends DbNoteRouter implements CommentListRoutable {
  @override
  void onViewAllComments(int productId, int type) {
    // Nếu có parentRouter (Plugin mode), gửi tín hiệu navigate cho parent xử lý
    parentRouter?.navigate(ViewAllCommentRoute(productId, type));
  }
}
