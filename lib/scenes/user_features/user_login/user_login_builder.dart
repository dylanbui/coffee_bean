/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 13:55
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_features/forgot_password/forgot_password_builder.dart';
import 'package:coffee_bean/scenes/user_features/privacy_policy/privacy_policy_builder.dart';
import 'package:coffee_bean/scenes/user_features/user_agreement/user_agreement_builder.dart';
import 'package:coffee_bean/scenes/user_features/user_login/interactor/user_login_interactor.dart';
import 'package:coffee_bean/scenes/user_features/user_login/interactor/user_login_page.dart';
import 'package:coffee_bean/scenes/user_features/user_register/user_register_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- ROUTE ---
class ForgotPasswordRoute implements DbNoteRoute {}
class UserRegisterRoute implements DbNoteRoute {}
class LoginSuccessRoute implements DbNoteRoute {}
class UserAgreementRoute implements DbNoteRoute {}
class PrivacyPolicyRoute implements DbNoteRoute {}


// --- ROUTER ---
class UserLoginRouter extends DbNoteRouter {
  UserLoginRouter();

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is LoginSuccessRoute) {
      navigator.pop(fromContext: fromContext);
    } else if (toRoute is UserRegisterRoute) {
      UserRegisterBuilder userRegisterBuilder = UserRegisterBuilder();
      navigator.push(userRegisterBuilder.build().viewController, fromContext: fromContext);
    } else if (toRoute is ForgotPasswordRoute) {
      ForgotPasswordBuilder forgotPasswordBuilder = ForgotPasswordBuilder();
      navigator.push(forgotPasswordBuilder.build().viewController, fromContext: fromContext);
    } else if (toRoute is UserAgreementRoute) {
      UserAgreementBuilder userAgreementBuilder = UserAgreementBuilder();
      navigator.push(userAgreementBuilder.build().viewController, fromContext: fromContext);
    } else if (toRoute is PrivacyPolicyRoute) {
      PrivacyPolicyBuilder privacyPolicyBuilder = PrivacyPolicyBuilder();
      navigator.push(privacyPolicyBuilder.build().viewController, fromContext: fromContext);
    }
  }
}


// --- BUILDER ---
class UserLoginBuilder implements DbNoteBuilder<UserLoginRouter> {
  UserLoginBuilder();

  @override
  UserLoginRouter build() {
    final router = UserLoginRouter();
    final interactor = UserLoginInteractor(router);
    final page = UserLoginPage(interactor: interactor);

    router.attach(interactor, page);

    return router;
  }

}
