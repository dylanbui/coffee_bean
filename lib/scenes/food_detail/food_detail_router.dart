import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';

abstract class FoodDetailRoutable implements DbNoteRoutable {
  void routeToCommentList(int productId, String type);
}

class FoodDetailRouter extends DbNoteRouter implements FoodDetailRoutable {
  @override
  void routeToCommentList(int productId, String type) {
    final builder = CommentListBuilder(productId: productId, type: type);
    final router = builder.build();
    navigator.push(router.viewController);
  }
}
