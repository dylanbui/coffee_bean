import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_features/user_auth_flow.dart';
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
    // final builder = UserRegisterBuilder();
    // navigator.push(builder.build().viewController);
    // Khởi chạy luồng Auth bắt đầu từ Login
    UserAuthFlow(startStep: AuthStartStep.register).start(this, listener);
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
