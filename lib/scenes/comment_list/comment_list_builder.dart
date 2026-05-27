import 'package:coffee_bean/scenes/comment_list/comment_list_router.dart';
import 'package:coffee_bean/scenes/comment_list/interactor/comment_list_interactor.dart';
import 'package:coffee_bean/scenes/comment_list/interactor/comment_list_page.dart';
import 'package:coffee_bean/scenes/comment_list/interactor/widget/comment_list_plugin.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

abstract interface class CommentListBuildable implements DbNoteBuildable {
  Widget buildPlugin(DbNoteRoutable? parentRouter);
}

class CommentListBuilder extends DbNoteBuilder<CommentListRouter> implements CommentListBuildable {
  final int productId;
  final String type;

  CommentListBuilder({required this.productId, required this.type});

  @override
  CommentListRouter build() {
    final router = CommentListRouter();
    final interactor = CommentListInteractor(router, productId, type, limit: 10);
    final page = CommentListPage(interactor: interactor);
    router.attach(interactor, page);

    return router;
  }

  @override
  Widget buildPlugin(DbNoteRoutable? parentRouter) {
    final router = CommentListRouter();
    // Khi dùng làm plugin, cấu hình limit = 2
    final interactor = CommentListInteractor(router, productId, type, limit: 2);
    final page = CommentListPlugin(interactor: interactor);
    router.attach(interactor, page);
    // Gán router cha (hỗ trợ chuyển kiểu tự động nhờ Covariant Override trong note_router.dart)
    router.parentRouter = parentRouter as DbNoteRouter;
    return router.viewController;
  }
}
