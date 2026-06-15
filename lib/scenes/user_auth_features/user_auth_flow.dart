import 'package:coffee_bean/data/local/user_manager/user_info.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_session.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/user_auth_features/forgot_password/forgot_password_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_login/user_login_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/user_register/user_register_builder.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';

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
      final session = parameters?['userSession'] as UserSession?;
      final info = parameters?['userInfo'] as UserInfo?;
      
      if (session != null && info != null) {
        handleAuthSuccess(session, info);
      } else {
        listener?.onAuthFlowCancelled(DbError(101, "Auth Data (Session/Info) not found !!"));
        finish();
      }
    }

    else if (toRoute is UserRegisterCompleteRoute) {
      if (UserManager().currentUser != null && UserManager().userInfo != null) {
        handleAuthSuccess(UserManager().currentUser!, UserManager().userInfo!);
      } else {
        listener?.onAuthFlowCancelled(DbError(101, "Auth Data (Session/Info) not found !!"));
        finish();
      }

      if (UserManager().isLogin) {
        // Registration flow - User is already logged in from Step 2
        // Fetch UserInfo to complete the profile
        // final userRepo = UserRepository();
        // final result = await userRepo.getUserInfo();
        // result.toResult().when(
        //   success: (info) {
        //     handleAuthSuccess(UserManager().currentUser!, info);
        //   },
        //   failure: (error) {
        //     // If failed to fetch info, still might want to proceed or show error
        //     // navigator.popToRoot(); // Go back to login if critical
        //   },
        // );
      } else {
        // Forgot Password flow - Just go back to login
        // navigator.popToRoot();
        // Maybe show a success message via toast
      }
    }
  }

  @override
  void onCancel() {
    listener?.onAuthFlowCancelled(DbError(100, "User cancel login action !!"));
    finish();
  }

  void handleAuthSuccess(UserSession session, UserInfo info) {
    // Lưu đồng thời cả 2 để đảm bảo đồng bộ
    UserManager().saveSession(session);
    UserManager().saveUserInfo(info);
    
    // iLog("AuthFlow: Đã lưu Session và Profile đồng bộ cho ${info.nickname}");

    listener?.onAuthFlowSuccess(session);

    // Tự động giải phóng stack và quay về màn hình trước khi bắt đầu Flow
    finish();
  }
}
