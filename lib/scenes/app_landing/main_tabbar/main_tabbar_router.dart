import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

abstract class MainTabbarRoutable implements DbNoteRoutable {}

class MainTabbarRouter extends DbNoteRouter implements MainTabbarRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // Implement navigation logic if needed
  }
}
