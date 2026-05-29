import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:db_core/architecture_ribs/note_flow.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_auth_features/forgot_password/forgot_password_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_login/user_login_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_register/user_register_builder.dart';
import 'package:db_core/commons_constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

// --- START STEP ENUM ---
enum AuthStartStep { login, register }

// --- LISTENER ---
abstract interface class UserAuthFlowListener {
  void onAuthFlowSuccess(UserSession userData);
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
      // Giả định params chứa UserSession sau khi login thành công từ Interactor
      final userData = parameters?['userData'] as UserSession?;
      if (userData != null) {
        handleAuthSuccess(userData);
      } else {
        listener?.onAuthFlowCancelled(DbError(101, "UserSession not found !!"));
        finish();
      }
    }
    else if (toRoute is UserRegisterCompleteRoute) {
      // Có thể tự động đăng nhập hoặc quay lại Login sau khi đăng ký thành công
      // handleAuthSuccess();
    }
  }

  @override
  void onCancel() {
    listener?.onAuthFlowCancelled(DbError(100, "User cancel login action !!"));
    finish();
  }

  void handleAuthSuccess(UserSession userData) {
    // 1. Lưu session vào UserManager (Global Source of Truth)
    UserManager().saveSession(userData);
    
    // 2. Trả về cho caller qua listener
    listener?.onAuthFlowSuccess(userData);

    // Tự động giải phóng stack và quay về màn hình trước khi bắt đầu Flow
    finish();
  }
}
