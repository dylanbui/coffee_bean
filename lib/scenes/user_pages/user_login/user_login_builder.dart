/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 13:55
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/architecture_ribs/navigator.dart';
import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/scenes/user_pages/forgot_password/forgot_password_builder.dart';
import 'package:coffee_bean/scenes/user_pages/privacy_policy/privacy_policy_builder.dart';
import 'package:coffee_bean/scenes/user_pages/user_agreement/user_agreement_builder.dart';
import 'package:coffee_bean/scenes/user_pages/user_login/interactor/user_login_interactor.dart';
import 'package:coffee_bean/scenes/user_pages/user_login/interactor/user_login_page.dart';
import 'package:coffee_bean/scenes/user_pages/user_register/user_register_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- LISTENER ---
// Defines the "contract" that the parent module must implement to receive notifications
// when this splash module completes.
// abstract interface class UserLoginListener {
//   void onUserLoginCompleted();
// }

// --- ROUTE ---
// A Route object to communicate the "completion" event from the Interactor to the Builder/Router.
class ForgotPasswordRoute implements DbNoteRoute {}
class UserRegisterRoute implements DbNoteRoute {}
class LoginSuccessRoute implements DbNoteRoute {}

class UserAgreementRoute implements DbNoteRoute {}
class PrivacyPolicyRoute implements DbNoteRoute {}


// --- BUILDER ---
// Responsible for initializing the Interactor, Page, and connecting them.
class UserLoginBuilder extends DbNoteBuilder with DbNavigator implements DbNoteRoutable {
  // final UserLoginListener listener;

  // UserLoginBuilder({required this.listener});
  UserLoginBuilder();

  @override
  ViewController buildFactory() {
    // The Interactor (Cubit) is created here. It receives a reference to the router (which is 'this').
    // final interactor = UserLoginInteractor(router: this);
    // final page = UserLoginPage();
    //
    // // BlocProvider "injects" the Cubit into the widget tree, making it accessible to the Page.
    // rootPage = BlocProvider<UserLoginInteractor>.value(value: interactor, child: page);
    // final page = UserLoginPage();
    // BlocProvider sẽ chịu trách nhiệm tạo interactor

    // TẠM THỜI thêm dòng này để debug
    // print("DEBUG: UserLoginBuilder build called at ${DateTime.now().millisecondsSinceEpoch}");
    // debugPrintStack(label: "DEBUG STACK TRACE"); // Nó sẽ in ra toàn bộ danh sách các hàm đang gọi build này

    // final interactor = UserLoginInteractor(router: this);
    // final page = UserLoginPage();
    // // BlocProvider "injects" the Cubit into the widget tree, making it accessible to the Page.
    // return BlocProvider<UserLoginInteractor>.value(value: interactor, child: page);

    // Cach 2
    final loginPage = BlocProvider<UserLoginInteractor>(
      create: (context) => UserLoginInteractor(router: this),
      child: UserLoginPage(),
    );
    return loginPage;
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is LoginSuccessRoute) {
      // Implement navigation or listener callback for successful login

    } else if (toRoute is UserRegisterRoute) {
      // Implement navigation to User Register scene
      UserRegisterBuilder userRegisterBuilder = UserRegisterBuilder();
      push(userRegisterBuilder.build());

    } else if (toRoute is ForgotPasswordRoute) {
      ForgotPasswordBuilder forgotPasswordBuilder = ForgotPasswordBuilder();
      push(forgotPasswordBuilder.build());

    } else if (toRoute is UserAgreementRoute) {
      UserAgreementBuilder userAgreementBuilder = UserAgreementBuilder();
      push(userAgreementBuilder.build());

    } else if (toRoute is PrivacyPolicyRoute) {
      PrivacyPolicyBuilder privacyPolicyBuilder = PrivacyPolicyBuilder();
      push(privacyPolicyBuilder.build());
    }
  }


}



