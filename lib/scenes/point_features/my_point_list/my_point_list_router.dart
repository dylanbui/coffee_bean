import 'package:coffee_bean/scenes/point_features/point_breakdown/point_breakdown_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

class RewardPointHistoryRoute implements DbNoteRoute {}

abstract class MyPointListRoutable implements DbNoteRoutable {}

class MyPointListRouter extends DbNoteRouter implements MyPointListRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // Implement navigation if needed
    if (toRoute is RewardPointHistoryRoute) {
      final builder = PointBreakdownBuilder();
      navigator.pushSameRootPage(builder.build().viewController);
    }
  }
  
}
