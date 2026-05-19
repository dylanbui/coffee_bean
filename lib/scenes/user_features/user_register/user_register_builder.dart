/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 18:59
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_features/privacy_policy/privacy_policy_builder.dart';
import 'package:coffee_bean/scenes/user_features/user_agreement/user_agreement_builder.dart';
import 'package:coffee_bean/scenes/user_features/user_register/interactor/user_register_interactor.dart';
import 'package:coffee_bean/scenes/user_features/user_register/interactor/user_register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- ROUTE ---
class UserRegisterCompleteRoute implements DbNoteRoute {}
class UserLoginRoute implements DbNoteRoute {}
class UserAgreementRoute implements DbNoteRoute {}
class PrivacyPolicyRoute implements DbNoteRoute {}

// --- ROUTER ---
class UserRegisterRouter extends DbNoteRouter {
  UserRegisterRouter();

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is UserRegisterCompleteRoute) {
      // Handle completion
    } else if (toRoute is UserLoginRoute) {
      navigator.pop(fromContext: fromContext);
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
class UserRegisterBuilder implements DbNoteBuilder<UserRegisterRouter> {
  UserRegisterBuilder();

  @override
  UserRegisterRouter build() {
    final router = UserRegisterRouter();
    final interactor = UserRegisterInteractor(router);
    final page = UserRegisterPage(interactor: interactor);

    router.attach(interactor, page);

    return router;
  }

}
