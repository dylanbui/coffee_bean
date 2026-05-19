import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_features/user_login/user_login_builder.dart';
import 'package:coffee_bean/scenes/user_features/user_register/user_register_builder.dart';
import 'package:flutter/cupertino.dart';

class UserLoginRoute implements DbNoteRoute {}

abstract class MyProfileRoutable implements DbNoteRoutable {
  void doLogin();
  void doRegister();
  void doLogout();
  void editProfile();
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
    final builder = UserLoginBuilder();
    navigator.push(builder.build().viewController);
  }

  @override
  void doRegister() {
    final builder = UserRegisterBuilder();
    navigator.push(builder.build().viewController);
  }

  @override
  void doLogout() {
    // TODO: implement doLogout
    debugPrint("doLogout");
  }

  @override
  void editProfile() {
    // TODO: implement editProfile
    debugPrint("editProfile");
  }


}
