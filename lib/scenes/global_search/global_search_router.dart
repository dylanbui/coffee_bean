/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 12/5/26 - 16:03
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';


// Route
class GlobalSearchRoute implements DbNoteRoute {
  final int id;

  GlobalSearchRoute(this.id);
}

// Router
class GlobalSearchRouter extends DbNoteRouter {

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is GlobalSearchRoute) {
      // Implementation for navigating to or within GlobalSearch
      // Ví dụ: xử lý điều hướng logic nội bộ của RIB GlobalSearch
    }
  }

}