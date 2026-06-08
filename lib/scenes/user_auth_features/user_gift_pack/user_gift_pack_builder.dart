/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 23:22
 * To change this template use File | Settings | File Templates.
 */

import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_gift_pack/interactor/user_gift_pack_interactor.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_gift_pack/interactor/user_gift_pack_page.dart';
import 'package:flutter/material.dart';


// --- ROUTE ---
class UserGiftPackCompleteRoute implements DbNoteRoute {}

// class UserGiftPackRouter extends DbNoteRouter {
//   UserGiftPackRouter();
//
//   @override
//   void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
//     if (toRoute is UserGiftPackCompleteRoute) {
//       navigator.pop(fromContext: fromContext);
//     }
//   }
//
// }
//
// class UserGiftPackBuilder extends DbNoteBuilder {
//
//   UserGiftPackBuilder();
//
//   @override
//   UserGiftPackRouter build() {
//     final router = UserGiftPackRouter();
//     final interactor = UserGiftPackInteractor(router: router);
//     final page = UserGiftPackPage(interactor: interactor);
//
//     router.attach(interactor, page);
//
//     return router;
//   }
//
//
// }


// --- BUILDER & ROUTER ---
class UserGiftPackBuilder extends DbNoteSimpleRouterBuilder {

  UserGiftPackBuilder();

  @override
  UserGiftPackBuilder build() {
    final interactor = UserGiftPackInteractor(router: this);
    final page = UserGiftPackPage(interactor: interactor);

    attach(interactor, page);

    return this;
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is UserGiftPackCompleteRoute) {
      // navigator.pop(fromContext: fromContext);
      parentRouter?.pop();
    }
  }
}
