/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 * To change this template use File | Settings | File Templates.
 */

import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_features/forgot_password/forgot_password_builder.dart';
import 'package:coffee_bean/scenes/user_features/set_password/set_password_builder.dart';
import 'package:flutter/material.dart';

// --- ROUTE ---
// A Route object to communicate the "completion" event from the Interactor to the Builder/Router.
class ForgotPasswordCompleteRoute implements DbNoteRoute {}

class ForgotPasswordRouter extends DbNoteRouter {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ForgotPasswordCompleteRoute) {
      // When the completion route is received, navigate to SetPassword.
      SetPasswordBuilder setPasswordBuilder = SetPasswordBuilder();
      // In RIBs architecture, building a module returns its Router.
      // We then push the Router's viewController (the Widget).
      final nextRouter = setPasswordBuilder.build();
      // Use the navigator inherited from DbNoteRouter
      parentRouter?.navigator.push(nextRouter.viewController);
    }
    else {
      parentRouter?.navigate(toRoute, fromContext: fromContext, routeName: routeName, parameters: parameters);
    }
  }
}
