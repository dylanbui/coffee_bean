import 'package:coffee_bean/scenes/reward_point_history/reward_point_history_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

class RewardPointHistoryRoute implements DbNoteRoute {}

abstract class StoreGetPointListRoutable implements DbNoteRoutable {}

class StoreGetPointListRouter extends DbNoteRouter implements StoreGetPointListRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // Implement navigation if needed
    if (toRoute is RewardPointHistoryRoute) {
      final builder = RewardPointHistoryBuilder();
      navigator.pushSameRootPage(builder.build().viewController);
    }
  }
  
}
