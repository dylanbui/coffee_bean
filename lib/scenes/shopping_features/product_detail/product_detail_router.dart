import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

abstract class ProductDetailRoutable implements DbNoteRoutable {
  void gotoCommentList(int productId, int type);
}

class ProductDetailRouter extends DbNoteRouter implements ProductDetailRoutable {

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
  }

  @override
  void gotoCommentList(int productId, int type) {
    final builder = CommentListBuilder(productId: productId, type: type);
    final router = builder.build();
    navigator.push(router.viewController);
  }
}
