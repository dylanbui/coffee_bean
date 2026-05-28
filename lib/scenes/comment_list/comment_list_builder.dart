import 'package:coffee_bean/scenes/comment_list/comment_list_router.dart';
import 'package:coffee_bean/scenes/comment_list/interactor/comment_list_interactor.dart';
import 'package:coffee_bean/scenes/comment_list/interactor/comment_list_page.dart';
import 'package:coffee_bean/scenes/comment_list/plugins/small_comment_list/comment_list_small_interactor.dart';
import 'package:coffee_bean/scenes/comment_list/plugins/small_comment_list/comment_list_small_widget.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_plugin.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

// Use for plugin CommentListSmall
abstract interface class CommentListSmallListener {
  // Bao cho parent class
  void onNavigateToAllComments(int productId, String type);
}

class CommentListSmallController extends DbPluginController<CommentListSmallInteractor, CommentListSmallListener> {
  void refresh() {
    // Gia lap goi Plugin refresh
    // interactor?.refreshData();
  }
}

abstract interface class CommentListBuildable implements DbNoteBuildable {
  Widget buildPlugin(int limitComments, CommentListSmallController controller);
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
  Widget buildPlugin(int limitComments, CommentListSmallController controller) {
    final router = CommentListRouter();
    // Sử dụng Interactor và Widget chuyên biệt cho Plugin Small
    final interactor = CommentListSmallInteractor(router, productId: productId, type: type, limitComments: limitComments, controller: controller);
    final page = CommentListSmallWidget(interactor: interactor);
    router.attach(interactor, page);
    return router.viewController;
  }
}
