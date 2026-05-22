/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 */

import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_interactor.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/rib_samples/auth_flow_sample/login_rib.dart';
import 'package:coffee_bean/scenes/rib_samples/auth_flow_sample/register_rib.dart';
import 'package:coffee_bean/scenes/rib_samples/auth_flow_sample/forgot_pw_rib.dart';
import 'package:flutter/material.dart';

// --- LISTENER (For Root Parent) ---
abstract interface class AuthFlowRibListener {
  void onAuthFlowCompleted(String userToken);
}

// --- INTERNAL ROUTES (Child -> AuthFlow communication) ---
class OpenRegisterRoute implements DbNoteRoute {}
class OpenForgotPwRoute implements DbNoteRoute {}
class AuthSuccessResultRoute implements DbNoteRoute {
  final String token;
  AuthSuccessResultRoute(this.token);
}

// --- ROUTER ---
class AuthFlowRouter extends DbNoteRouter {
  String? flowBaseRouteName;

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
      // Pass the success result to the interactor
      (interactor as AuthFlowInteractor).handleAuthSuccess(toRoute.token);
    }
  }

  void cleanupFlow() {
    if (flowBaseRouteName != null) {
      // Clear all pages pushed by this flow
      navigator.popUntilBefore(flowBaseRouteName!);
    }
  }
}

// --- INTERACTOR ---
class AuthFlowInteractor extends DbNoteInteractor<AuthFlowRouter> {
  final AuthFlowRibListener listener;

  AuthFlowInteractor(AuthFlowRouter router, this.listener) {
    this.router = router;
  }

  void handleAuthSuccess(String token) {
    // 1. Pop all flow pages
    router?.cleanupFlow();
    // 2. Notify root parent
    listener.onAuthFlowCompleted(token);
  }
}

// --- BUILDER ---
class AuthFlowBuilder extends DbNoteBuilder<AuthFlowRouter> {
  final AuthFlowRibListener listener;
  AuthFlowBuilder({required this.listener});

  @override
  AuthFlowRouter build() {
    final router = AuthFlowRouter();
    final interactor = AuthFlowInteractor(router, listener);
    
    // 1. Build the first module of the flow
    final loginBuilder = LoginBuilder();
    final loginRouter = loginBuilder.build();

    // 2. IMPORTANT: Set this AuthFlowRouter as the parent of the child router
    loginRouter.parentRouter = router;

    // 3. Define a unique route name for the start of the flow to use popUntilBefore later
    router.flowBaseRouteName = "AuthFlow_Root_${DateTime.now().millisecondsSinceEpoch}";

    // 4. Attach interactor and use login's view as AuthFlow's representative view
    router.attach(interactor, loginRouter.viewController);

    return router;
  }
}
