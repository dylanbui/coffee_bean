/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 17:35
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/architecture_ribs/navigator.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/scenes/user_pages/set_password/interactor/set_password_interactor.dart';
import 'package:coffee_bean/scenes/user_pages/set_password/interactor/set_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// --- ROUTE ---
// A Route object to communicate the "completion" event from the Interactor to the Builder/Router.
class SetPasswordCompleteRoute implements DbNoteRoute {}

// --- BUILDER ---
// Responsible for initializing the Interactor, Page, and connecting them.
class SetPasswordBuilder extends DbNoteBuilder with DbNavigator implements DbNoteRoutable {

  SetPasswordBuilder();

  @override
  ViewController buildFactory() {
    // The Interactor (Cubit) is created here. It receives a reference to the router (which is 'this').
    final interactor = SetPasswordInteractor(router: this);
    final page = SetPasswordPage();

    // BlocProvider "injects" the Cubit into the widget tree, making it accessible to the Page.
    return BlocProvider<SetPasswordInteractor>.value(value: interactor, child: page);
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is SetPasswordCompleteRoute) {

    }
  }
}



