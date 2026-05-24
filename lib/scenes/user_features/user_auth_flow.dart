import 'package:db_core/architecture_ribs/note_flow.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_features/forgot_password/forgot_password_builder.dart';
import 'package:coffee_bean/scenes/user_features/user_login/user_login_builder.dart';
import 'package:coffee_bean/scenes/user_features/user_register/user_register_builder.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

// --- START STEP ENUM ---
enum AuthStartStep { login, register }

// --- LISTENER ---
abstract interface class UserAuthFlowListener {
  void onAuthSuccess();
  void onAuthCancelled();
}

// --- FLOW IMPLEMENTATION ---
class UserAuthFlow extends DbNoteFlow<UserAuthFlowListener> {
  final AuthStartStep startStep;

  UserAuthFlow({this.startStep = AuthStartStep.login});
  
  @override
  void onStart() {
    if (startStep == AuthStartStep.register) {
      // Bắt đầu trực tiếp từ Register nếu yêu cầu
      final regRouter = UserRegisterBuilder().build();
      regRouter.parentRouter = this;
      runFlow(regRouter.interactor, regRouter.viewController, 
              transitionType: PageTransitionType.rightToLeft);
    } else {
      // Mặc định bắt đầu từ Login
      final loginRouter = UserLoginBuilder().build();
      loginRouter.parentRouter = this;
      runFlow(loginRouter.interactor, loginRouter.viewController, 
              transitionType: PageTransitionType.rightToLeft);
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
    // Luong con cua forgot password, de no chuyen cho nhe
    // else if (toRoute is ForgotPasswordCompleteRoute) {
    //   // Chuyển sang đặt lại mật khẩu sau khi hoàn thành quên mật khẩu
    //   final setPwRouter = SetPasswordBuilder().build();
    //   setPwRouter.parentRouter = this;
    //   navigator.push(setPwRouter.viewController);
    // }
    else if (toRoute is LoginSuccessRoute) {
      handleAuthSuccess();
    }
    else if (toRoute is UserRegisterCompleteRoute) {
      // Có thể tự động đăng nhập hoặc quay lại Login sau khi đăng ký thành công
      handleAuthSuccess();
    }
  }

  @override
  void onCancel() {
    listener?.onAuthCancelled();
  }

  void handleAuthSuccess() {
    // Bắn event thông báo login thành công cho toàn hệ thống
    // Co nhieu cach de xu ly cho nay, ta co the push thong bao ket thuc luong o day, hay goi callback deu duoc
    // locator<DbEventBus>().fire(UserLoginSuccessEvent());
    listener?.onAuthSuccess();
    // Tự động giải phóng stack và quay về màn hình trước khi bắt đầu Flow
    finish();
  }
}
