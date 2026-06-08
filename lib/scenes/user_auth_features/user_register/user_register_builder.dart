/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 18:59
 * To change this template use File | Settings | File Templates.
 */

import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_auth_features/privacy_policy/privacy_policy_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/set_password/set_password_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_agreement/user_agreement_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_login/user_login_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_register/interactor/user_register_interactor.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_register/interactor/user_register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- ROUTE ---
class UserRegisterCompleteRoute implements DbNoteRoute {}
class UserSetPasswordRoute implements DbNoteRoute {}
class UserLoginRoute implements DbNoteRoute {}
class UserAgreementRoute implements DbNoteRoute {}
class PrivacyPolicyRoute implements DbNoteRoute {}

// --- ROUTER ---
class UserRegisterRouter extends DbNoteRouter {
  UserRegisterRouter();

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // Day la nhung luong phu, goi parent xu ly nhung code de o day cho nhe,  main flow se day len parent
    if (toRoute is UserAgreementRoute) {
      UserAgreementBuilder userAgreementBuilder = UserAgreementBuilder();
      // Neu can xu ly thi set router => userAgreementRouter.parentRouter = parentRouter;
      parentRouter?.push(userAgreementBuilder.build().viewController);

    } else if (toRoute is PrivacyPolicyRoute) {
      PrivacyPolicyBuilder privacyPolicyBuilder = PrivacyPolicyBuilder();
      // Neu can xu ly thi set router => privacyPolicyRouter.parentRouter = parentRouter;
      parentRouter?.push(privacyPolicyBuilder.build().viewController);

    } else if (toRoute is UserSetPasswordRoute) {
      final setPasswordRouter = SetPasswordBuilder().build();
      setPasswordRouter.parentRouter = parentRouter;
      parentRouter?.push(setPasswordRouter.viewController);

    } else if (toRoute is UserLoginRoute) {
      final userLoginRouter = UserLoginBuilder().build();
      userLoginRouter.parentRouter = this;
      parentRouter?.push(userLoginRouter.viewController);

    } else {
      // Đẩy các route khác (UserLoginRoute, UserRegisterCompleteRoute) lên cho Flow xử lý
      parentRouter?.navigate(toRoute, fromContext: fromContext, routeName: routeName, parameters: parameters);
    }
  }
}

// --- BUILDER ---
class UserRegisterBuilder extends DbNoteBuilder<UserRegisterRouter> {
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
