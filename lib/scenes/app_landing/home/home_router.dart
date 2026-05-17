import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/global_search/global_search_builder.dart';
import 'package:flutter/material.dart';

// Route
class ChooseStoreRoute implements DbNoteRoute {}

abstract class HomeRoutable implements DbNoteRoutable {}

class HomeRouter extends DbNoteRouter implements HomeRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ChooseStoreRoute) {
      final nextBuilder = GlobalSearchBuilder();
      final nextRouter = nextBuilder.build();
      navigator.push(nextRouter.viewController, fromContext: fromContext);
    }
  }
}
