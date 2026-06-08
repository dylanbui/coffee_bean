import 'package:coffee_bean/scenes/point_features/point_breakdown/point_breakdown_builder.dart';
import 'package:coffee_bean/scenes/point_features/point_task/point_task_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

class PointBreakdownRoute implements DbNoteRoute {}
class PointTaskRoute implements DbNoteRoute {}

abstract class MyPointListRoutable implements DbNoteRoutable {}

class MyPointListRouter extends DbNoteRouter implements MyPointListRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // Implement navigation if needed
    if (toRoute is PointBreakdownRoute) {
      final builder = PointBreakdownBuilder();
      navigator.push(builder.build().viewController);
    } else if (toRoute is PointTaskRoute) {
      final builder = PointTaskBuilder();
      navigator.push(builder.build().viewController);
    }
  }
  
}
