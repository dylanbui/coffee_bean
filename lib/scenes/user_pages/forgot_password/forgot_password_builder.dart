/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/architecture_ribs/navigator.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_pages/forgot_password/interactor/forgot_password_interactor.dart';
import 'package:coffee_bean/scenes/user_pages/forgot_password/interactor/forgot_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- LISTENER ---
// Defines the "contract" that the parent module must implement to receive notifications
// when this splash module completes.
// abstract interface class ForgotPasswordListener {
//   void onForgotPasswordCompleted();
// }

// --- ROUTE ---
// A Route object to communicate the "completion" event from the Interactor to the Builder/Router.
class ForgotPasswordCompleteRoute implements DbNoteRoute {}

// --- BUILDER ---
// Responsible for initializing the Interactor, Page, and connecting them.
class ForgotPasswordBuilder extends DbNoteBuilder with DbNavigator implements DbNoteRoutable {


  ForgotPasswordBuilder();

  @override
  Widget build() {
    // The Interactor (Cubit) is created here. It receives a reference to the router (which is 'this').
    final interactor = ForgotPasswordInteractor(router: this);
    final page = ForgotPasswordPage();

    // BlocProvider "injects" the Cubit into the widget tree, making it accessible to the Page.
    rootPage = BlocProvider<ForgotPasswordInteractor>.value(value: interactor, child: page);
    return rootPage;
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ForgotPasswordCompleteRoute) {
      // When the completion route is received, notify the parent module's listener.

    }
  }
}



