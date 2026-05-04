/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 1/5/26 - 14:45
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';


// Route
class DialogDemoRoute implements DbNoteRoute {
  final int id;

  DialogDemoRoute(this.id);
}

// Router
class DialogDemoRouter extends DbNoteRouter {

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is DialogDemoRoute) {
      // Implementation for navigating to or within DialogDemo
      // Ví dụ: xử lý điều hướng logic nội bộ của RIB DialogDemo
    }
  }

}