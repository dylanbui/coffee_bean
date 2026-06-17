import 'package:coffee_bean/scenes/my_profile_features/update_profile/update_profile_builder.dart';
import 'package:db_core/architecture_ribs/navigator.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_auth_flow.dart';
import 'package:flutter/cupertino.dart';

abstract class MyProfileRoutable implements DbNoteRoutable {
  void doLoginFlow(UserAuthFlowListener listener);
  void doRegisterFlow(UserAuthFlowListener listener);
  void doLogout();
  void editProfile();
}

class MyProfileRouter extends DbNoteRouter implements MyProfileRoutable {
  
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // Xử lý các điều hướng khác của Profile tại đây
  }

  @override
  void doLoginFlow(UserAuthFlowListener listener) {
    // Khởi chạy luồng Auth bắt đầu từ Login
    UserAuthFlow(startStep: AuthStartStep.login).start(this, listener);
  }

  @override
  void doRegisterFlow(UserAuthFlowListener listener) {
    // Khởi chạy luồng Auth bắt đầu từ Login
    UserAuthFlow(startStep: AuthStartStep.register).start(this, listener);
  }

  @override
  void doLogout() {
    // Route to other after logout
    debugPrint("doLogout");
  }

  @override
  void editProfile() {
    final builder = UpdateProfileBuilder().build();
    push(builder.viewController);
  }

}
