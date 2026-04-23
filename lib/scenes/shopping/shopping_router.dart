import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:flutter/cupertino.dart';

abstract class ShoppingRoutable implements DbNoteRoutable {
}

class ShoppingRouter extends DbNoteRouter implements ShoppingRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
  }
}
