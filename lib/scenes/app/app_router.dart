// This file defines logical routes for navigation, especially for deep linking.
// They are simple data classes that carry the necessary parameters for a destination.


import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:flutter/cupertino.dart';




class AppRouter extends DbNoteRouter {

  void successSyncDataFormServer() {
    // Load trang dau tien
    //   MainTabbarBuilder mainTabbarBuilder = MainTabbarBuilder();
    //   pushSameRootPage(mainTabbarBuilder.build());
  }


  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {

  }

}
