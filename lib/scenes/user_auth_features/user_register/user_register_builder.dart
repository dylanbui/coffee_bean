/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 18:59
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/scenes/user_auth_features/app_agreement/app_agreement_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/set_password/set_password_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_register/interactor/user_register_interactor.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_register/interactor/user_register_page.dart';
import 'package:coffee_bean/shared/i18n/locale_keys.g.dart';
import 'package:db_core/db_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
      final builder = AppAgreementBuilder(type: 3, title: LocaleKeys.user_auth_features_user_login_user_agreement_link.tr());
      parentRouter?.push(builder.build().viewController, transitionType: PageTransitionType.bottomToTop);

    } else if (toRoute is PrivacyPolicyRoute) {
      final builder = AppAgreementBuilder(type: 4, title: LocaleKeys.user_auth_features_user_login_privacy_policy_link.tr());
      parentRouter?.push(builder.build().viewController, transitionType: PageTransitionType.bottomToTop);

    } else if (toRoute is UserSetPasswordRoute) {
      final mobile = parameters?['mobile'] as String? ?? '';
      final code = parameters?['code'] as String? ?? '';

      final setPasswordRouter = SetPasswordBuilder(
        mobile: mobile,
        code: code,
        mode: SetPasswordMode.registration,
      ).build();
      setPasswordRouter.parentRouter = parentRouter;
      parentRouter?.push(setPasswordRouter.viewController);

    } else {
      // Đẩy tất cả các route khác lên cho Flow xử lý (bao gồm UserLoginRoute)
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
