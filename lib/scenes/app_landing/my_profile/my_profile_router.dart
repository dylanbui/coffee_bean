import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_features/user_login/user_login_builder.dart';
import 'package:flutter/cupertino.dart';

class UserLoginRoute implements DbNoteRoute {}

abstract class MyProfileRoutable implements DbNoteRoutable {
  void doLogin();
  void doLogout();
}

class MyProfileRouter extends DbNoteRouter implements MyProfileRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is UserLoginRoute) {
      UserLoginBuilder builder = UserLoginBuilder();
      navigator.push(builder.build().viewController, fromContext: fromContext);
    }
  }

  @override
  void doLogin() {
    // UserLoginBuilder builder = UserLoginBuilder();
    // navigator.push(builder.build().viewController);
  }

  @override
  void doLogout() {
    // TODO: implement doLogout
  }
}
