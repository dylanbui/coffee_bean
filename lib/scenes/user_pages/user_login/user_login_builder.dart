/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 13:55
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/architecture_ribs/navigator.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_pages/user_login/interactor/user_login_interactor.dart';
import 'package:coffee_bean/scenes/user_pages/user_login/interactor/user_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- LISTENER ---
// Defines the "contract" that the parent module must implement to receive notifications
// when this splash module completes.
// abstract interface class UserLoginListener {
//   void onUserLoginCompleted();
// }

// --- ROUTE ---
// A Route object to communicate the "completion" event from the Interactor to the Builder/Router.
class ForgotPasswordRoute implements DbNoteRoute {}
class UserRegisterRoute implements DbNoteRoute {}
class LoginSuccessRoute implements DbNoteRoute {}


// --- BUILDER ---
// Responsible for initializing the Interactor, Page, and connecting them.
class UserLoginBuilder extends DbNoteBuilder with DbNavigator implements DbNoteRoutable {
  // final UserLoginListener listener;

  // UserLoginBuilder({required this.listener});
  UserLoginBuilder();

  @override
  Widget build() {
    // The Interactor (Cubit) is created here. It receives a reference to the router (which is 'this').
    final interactor = UserLoginInteractor(router: this);
    final page = UserLoginPage();

    // BlocProvider "injects" the Cubit into the widget tree, making it accessible to the Page.
    rootPage = BlocProvider<UserLoginInteractor>.value(value: interactor, child: page);
    return rootPage;
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ForgotPasswordRoute) {
      // When the completion route is received, notify the parent module's listener.
      // listener.onUserLoginCompleted();
    } else if (toRoute is UserRegisterRoute) {
      // Implement navigation to User Register scene
    } else if (toRoute is LoginSuccessRoute) {
      // Implement navigation or listener callback for successful login
    }
  }
}



