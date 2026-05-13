import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:flutter/cupertino.dart';

abstract class CommunityRoutable implements DbNoteRoutable {
}

class CommunityRouter extends DbNoteRouter implements CommunityRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
  }
}
