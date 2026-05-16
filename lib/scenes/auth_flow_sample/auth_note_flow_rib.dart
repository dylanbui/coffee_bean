/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 16:00
 */

import 'package:coffee_bean/core/architecture_ribs/note_flow.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/auth_flow_sample/auth_flow_rib.dart';
import 'package:coffee_bean/scenes/auth_flow_sample/login_rib.dart';
import 'package:coffee_bean/scenes/auth_flow_sample/register_rib.dart';
import 'package:coffee_bean/scenes/auth_flow_sample/forgot_pw_rib.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

// --- LISTENER ---
abstract interface class AuthNoteFlowListener {
  void onAuthFlowCompleted(String token);
  void onAuthFlowCancelled();
}

// --- FLOW IMPLEMENTATION ---
class AuthNoteFlow extends DbNoteFlow<AuthNoteFlowListener> {
  
  @override
  void onStart() {
    // 1. Act as a Builder for the first module (Login)
    final loginRouter = LoginBuilder().build();
    
    // 2. Set this Flow as the parent to handle internal navigation
    loginRouter.parentRouter = this;

    // 3. Launch the flow (Login as initial page)
    // Using bottomToTop to show the whole Auth process as a Modal
    runFlow(loginRouter.interactor, loginRouter.viewController, transitionType: PageTransitionType.bottomToTop);
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is OpenRegisterRoute) {
      final regRouter = RegisterBuilder().build();
      regRouter.parentRouter = this;
      navigator.push(regRouter.viewController);
    } 
    else if (toRoute is OpenForgotPwRoute) {
      final forgotRouter = ForgotPwBuilder().build();
      forgotRouter.parentRouter = this;
      navigator.push(forgotRouter.viewController);
    }
    else if (toRoute is AuthSuccessResultRoute) {
      handleAuthSuccess(toRoute.token);
    }
  }

  @override
  void onCancel() {
    listener?.onAuthFlowCancelled();
  }

  void handleAuthSuccess(String token) {
    listener?.onAuthFlowCompleted(token);
    // Auto-cleanup: Closes all pages in the Auth stack
    finish();
  }
}
