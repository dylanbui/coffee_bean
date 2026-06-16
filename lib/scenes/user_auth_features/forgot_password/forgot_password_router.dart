/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 * To change this template use File | Settings | File Templates.
 */

import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_auth_features/forgot_password/forgot_password_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/set_password/set_password_builder.dart';
import 'package:flutter/material.dart';

// --- ROUTE ---
// A Route object to communicate the "completion" event from the Interactor to the Builder/Router.
class ForgotPasswordCompleteRoute implements DbNoteRoute {}

class ForgotPasswordRouter extends DbNoteRouter {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ForgotPasswordCompleteRoute) {
      // Khi nhận được route hoàn tất nhập phone/code, chuyển sang màn hình đặt mật khẩu mới
      final mobile = parameters?['mobile'] as String? ?? '';
      final code = parameters?['code'] as String? ?? '';

      final setPasswordRouter = SetPasswordBuilder(
        mobile: mobile,
        code: code,
        mode: SetPasswordMode.forgotPassword,
      ).build();
      setPasswordRouter.parentRouter = parentRouter;
      parentRouter?.push(setPasswordRouter.viewController);
    }
    else {
      parentRouter?.navigate(toRoute, fromContext: fromContext, routeName: routeName, parameters: parameters);
    }
  }
}
