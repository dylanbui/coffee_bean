import 'package:coffee_bean/scenes/comment_list/comment_list_router.dart';
import 'package:coffee_bean/scenes/comment_list/interactor/comment_list_interactor.dart';
import 'package:coffee_bean/scenes/comment_list/interactor/comment_list_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';

class CommentListBuilder extends DbNoteBuilder<CommentListRouter> {
  final int productId;
  final String type;

  CommentListBuilder({required this.productId, required this.type});

  @override
  CommentListRouter build() {
    final router = CommentListRouter();
    final interactor = CommentListInteractor(router, productId, type);
    final page = CommentListPage(interactor: interactor);
    router.attach(interactor, page);

    return router;
  }
}
