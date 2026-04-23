import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:flutter/cupertino.dart';

abstract class MyProfileRoutable implements DbNoteRoutable {
}

class MyProfileRouter extends DbNoteRouter implements MyProfileRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
  }
}
