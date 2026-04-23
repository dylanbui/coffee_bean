
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:flutter/cupertino.dart';

abstract class HomeRoutable implements DbNoteRoutable {
}

class HomeRouter extends DbNoteRouter implements HomeRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
  }
}
