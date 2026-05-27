import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:coffee_bean/scenes/comment_list/comment_list_router.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

abstract class FoodDetailRoutable implements DbNoteRoutable {

}

class FoodDetailRouter extends DbNoteRouter implements FoodDetailRoutable {

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ViewAllCommentRoute) {
      final builder = CommentListBuilder(productId: toRoute.productId, type: toRoute.type);
      final router = builder.build();
      navigator.push(router.viewController);
    }
  }
}
