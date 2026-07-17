import 'package:coffee_bean/scenes/comment_list/comment_list_router.dart';
import 'package:coffee_bean/scenes/comment_list/interactor/comment_list_interactor.dart';
import 'package:coffee_bean/scenes/comment_list/interactor/comment_list_page.dart';
import 'package:coffee_bean/scenes/comment_list/plugins/small_comment_list/comment_list_small_interactor.dart';
import 'package:coffee_bean/scenes/comment_list/plugins/small_comment_list/comment_list_small_widget.dart';
import 'package:coffee_bean/scenes/comment_list/plugins/create_comment/interactor/create_comment_interactor.dart';
import 'package:coffee_bean/scenes/comment_list/plugins/create_comment/interactor/create_comment_widget.dart';
import 'package:coffee_bean/scenes/comment_list/comment_constant.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_plugin.dart';
import 'package:flutter/material.dart';

// Use for plugin CommentListSmall
abstract interface class CommentListSmallListener {
  // Bao cho parent class
  void onNavigateToAllComments(int resourceId, int type);
}

class CommentListSmallController extends DbPluginController<CommentListSmallInteractor, CommentListSmallListener> {
  void refresh() {
    // Gia lap goi Plugin refresh
    // interactor?.refreshData();
  }
}

abstract interface class CommentListBuildable implements DbNoteBuildable {
  Widget buildPlugin(int limitComments, CommentListSmallController controller);
  Widget buildCreateCommentPlugin(CreateCommentListener? listener);
}

class CommentListBuilder extends DbNoteBuilder<CommentListRouter> implements CommentListBuildable {
  final int resourceId;
  final CommentSource source;
  final int type;

  CommentListBuilder({
    required this.resourceId, 
    this.source = CommentSource.product, 
    this.type = 0
  });

  @override
  CommentListRouter build() {
    final router = CommentListRouter();
    final interactor = CommentListInteractor(router, resourceId, source, type, pageSize: 10);
    final page = CommentListPage(interactor: interactor);
    router.attach(interactor, page);

    return router;
  }

  @override
  Widget buildPlugin(int limitComments, CommentListSmallController controller) {
    final router = CommentListRouter();
    // Sử dụng Interactor và Widget chuyên biệt cho Plugin Small
    final interactor = CommentListSmallInteractor(
      router, 
      resourceId: resourceId, 
      source: source,
      type: type, 
      limitComments: limitComments, 
      controller: controller
    );
    final page = CommentListSmallWidget(interactor: interactor);
    router.attach(interactor, page);
    return router.viewController;
  }

  @override
  Widget buildCreateCommentPlugin(CreateCommentListener? listener) {
    final router = CommentListRouter();
    final interactor = CreateCommentInteractor(
      resourceId: resourceId,
      source: source,
      listener: listener,
    );
    final page = CreateCommentWidget(interactor: interactor);
    router.attach(interactor, page);
    return router.viewController;
  }
}
