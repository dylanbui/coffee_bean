/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 23:22
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/architecture_ribs/navigator.dart';
import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/scenes/user_pages/user_gift_pack/interactor/user_gift_pack_interactor.dart';
import 'package:coffee_bean/scenes/user_pages/user_gift_pack/interactor/user_gift_pack_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// --- ROUTE ---
// A Route object to communicate the "completion" event from the Interactor to the Builder/Router.
class UserGiftPackCompleteRoute implements DbNoteRoute {}

// --- BUILDER ---
// Responsible for initializing the Interactor, Page, and connecting them.
class UserGiftPackBuilder extends DbNoteBuilder with DbNavigator implements DbNoteRoutable {
  UserGiftPackBuilder();

  @override
  ViewController buildFactory() {
    // The Interactor (Cubit) is created here. It receives a reference to the router (which is 'this').
    final interactor = UserGiftPackInteractor(router: this);
    final page = UserGiftPackPage();

    // BlocProvider "injects" the Cubit into the widget tree, making it accessible to the Page.
    return BlocProvider<UserGiftPackInteractor>.value(value: interactor, child: page);
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is UserGiftPackCompleteRoute) {

    }
  }
}



