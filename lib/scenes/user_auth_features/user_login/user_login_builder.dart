/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 13:55
 * To change this template use File | Settings | File Templates.
 */

import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_dependency.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_auth_features/forgot_password/forgot_password_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/privacy_policy/privacy_policy_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_agreement/user_agreement_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_login/interactor/user_login_interactor.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_login/interactor/user_login_page.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_register/user_register_builder.dart';
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
    // Day la nhung luong phu, goi parent xu ly nhung code de o day cho nhe,  main flow se day len parent
    if (toRoute is UserAgreementRoute) {
      UserAgreementBuilder userAgreementBuilder = UserAgreementBuilder();
      parentRouter?.navigator.push(userAgreementBuilder.build().viewController, fromContext: fromContext);

    } else if (toRoute is PrivacyPolicyRoute) {
      PrivacyPolicyBuilder privacyPolicyBuilder = PrivacyPolicyBuilder();
      parentRouter?.navigator.push(privacyPolicyBuilder.build().viewController, fromContext: fromContext);
      
    } else {
      // Đẩy các route khác (LoginSuccess, UserRegister, ForgotPassword) lên cho Flow xử lý
      parentRouter?.navigate(toRoute, fromContext: fromContext, routeName: routeName, parameters: parameters);
    }
  }
}

abstract class UserLoginBuildable implements DbNoteBuildable  {
  UserLoginRouter build();
}

// --- BUILDER ---
class UserLoginBuilder extends DbNoteBuilder implements UserLoginBuildable {
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
