// This file defines logical routes for navigation, especially for deep linking.
// They are simple data classes that carry the necessary parameters for a destination.

import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/app_landing/main_tabbar/main_tabbar_builder.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/shopping_builder.dart';
import 'package:coffee_bean/scenes/store_list/store_list_builder.dart';
import 'package:coffee_bean/scenes/user_features/user_login/user_login_builder.dart';
import 'package:flutter/cupertino.dart';

class AppRouter extends DbNoteRouter {
  void successSyncDataFormServer() {
    // Load trang dau tien
    MainTabbarBuilder mainTabbarBuilder = MainTabbarBuilder();
    final router = mainTabbarBuilder.build();
    navigator.pushSameRootPage(router.viewController);

    // final builder = StoreListBuilder();
    // navigator.pushSameRootPage(builder.build().viewController);
    // UserLoginBuilder builder = UserLoginBuilder();
    // navigator.pushSameRootPage(builder.build().viewController,);

    // final builder = ShoppingBuilder();
    // navigator.pushSameRootPage(builder.build().viewController);

  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {}
}
