import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:coffee_bean/scenes/user_auth_features/forgot_password/forgot_password_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/set_password/set_password_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_login/user_login_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_register/user_register_builder.dart';
import 'package:coffee_bean/utils/flash_utils/flash_toast_helper.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';

// --- START STEP ENUM ---
enum AuthStartStep { login, register }

// --- AUTH RESULT (Sealed Class) ---
sealed class AuthResult {}

class LoginSuccess extends AuthResult {
  final UserSession session;
  LoginSuccess(this.session);
}

class RegisterSuccess extends AuthResult {
  final UserSession session;
  RegisterSuccess(this.session);
}

class ResetPasswordSuccess extends AuthResult {}

// --- LISTENER ---
abstract interface class UserAuthFlowListener {
  void onAuthFlowCompleted(AuthResult result);
  void onAuthFlowCancelled(DbError error);
}

// --- FLOW IMPLEMENTATION ---
class UserAuthFlow extends DbNoteFlow<UserAuthFlowListener> {
  final AuthStartStep startStep;
  final PageTransitionType transitionType;

  UserAuthFlow({
    this.startStep = AuthStartStep.login,
    this.transitionType = PageTransitionType.bottomToTop,
  });
  
  @override
  void onStart() {
    if (startStep == AuthStartStep.register) {
      // Bắt đầu trực tiếp từ Register nếu yêu cầu
      final regRouter = UserRegisterBuilder().build();
      regRouter.parentRouter = this;
      runFlow(regRouter.interactor, regRouter.viewController, 
              transitionType: transitionType);
    } else {
      // Mặc định bắt đầu từ Login
      final loginRouter = UserLoginBuilder().build();
      loginRouter.parentRouter = this;
      runFlow(loginRouter.interactor, loginRouter.viewController, 
              transitionType: transitionType);
    }
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // Xử lý điều hướng tập trung cho toàn bộ luồng Auth
    if (toRoute is UserRegisterRoute) {
      final regRouter = UserRegisterBuilder().build();
      regRouter.parentRouter = this;
      navigator.push(regRouter.viewController);
    } 
    else if (toRoute is ForgotPasswordRoute) {
      final forgotRouter = ForgotPasswordBuilder().build();
      forgotRouter.parentRouter = this;
      navigator.push(forgotRouter.viewController);
    }
    else if (toRoute is UserLoginRoute) {
      final loginRouter = UserLoginBuilder().build();
      loginRouter.parentRouter = this;
      navigator.push(loginRouter.viewController);
    }
    
    else if (toRoute is LoginSuccessRoute) {
      final session = UserManager().currentUser;
      final info = UserManager().userInfo;
      
      if (session != null && info != null) {
        listener?.onAuthFlowCompleted(LoginSuccess(session));
        finish();
      } else {
        listener?.onAuthFlowCancelled(DbError(101, "Auth Data (Session/Info) not found !!"));
        finish();
      }
    }

    else if (toRoute is SetPasswordRegistrationDoneRoute) {
      final session = UserManager().currentUser;
      final info = UserManager().userInfo;

      if (session != null && info != null) {
        // _syncAuthData(session, info);
        // Lưu đồng thời cả 2 để đảm bảo đồng bộ dữ liệu local
        // UserManager().saveSession(session);
        // UserManager().saveUserInfo(info);
        listener?.onAuthFlowCompleted(RegisterSuccess(session));
        finish();
      } else {
        listener?.onAuthFlowCancelled(DbError(101, "Auth Data (Session/Info) not found !!"));
        finish();
      }
    }
    else if (toRoute is SetPasswordResetDoneRoute) {
      // if (fromContext != null) {
      //   FlashToastHelper.success(fromContext, "Đặt lại mật khẩu thành công. Vui lòng đăng nhập lại.");
      // }
      listener?.onAuthFlowCompleted(ResetPasswordSuccess());
      finish();
    }
  }

  @override
  void onCancel() {
    listener?.onAuthFlowCancelled(DbError(100, "User cancel login action !!"));
    finish();
  }

  // void _syncAuthData(UserSession session, UserInfo info) {
  //   // Lưu đồng thời cả 2 để đảm bảo đồng bộ dữ liệu local
  //   UserManager().saveSession(session);
  //   UserManager().saveUserInfo(info);
  // }
}
