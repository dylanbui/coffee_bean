/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 */

import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/scenes/auth_flow_sample/auth_flow_rib.dart';
import 'package:flutter/material.dart';

// --- STATE ---
class LoginState extends BaseBlocState {}

// --- INTERACTOR ---
class LoginInteractor extends CubitInteractor<LoginRouter, LoginState> {
  LoginInteractor(LoginRouter router) : super(LoginState(), router: router);

  // Instead of a local listener, we send routes to the parent router
  void onLoginPressed() => router?.parentRouter?.navigate(AuthSuccessResultRoute("TOKEN_LOGIN_123"));
  void onRegisterPressed() => router?.parentRouter?.navigate(OpenRegisterRoute());
  void onForgotPwPressed() => router?.parentRouter?.navigate(OpenForgotPwRoute());
}

// --- ROUTER ---
class LoginRouter extends DbNoteRouter {}

// --- BUILDER ---
class LoginBuilder extends DbNoteBuilder<LoginRouter> {
  @override
  LoginRouter build() {
    final router = LoginRouter();
    final interactor = LoginInteractor(router);
    final page = LoginPage(interactor: interactor);
    
    router.attach(interactor, page);
    return router;
  }
}

// --- PAGE ---
class LoginPage extends CubitStateFulWidget<LoginInteractor, LoginState> {
  LoginPage({super.key, required super.interactor});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends CubitState<LoginPage, LoginInteractor, LoginState> {
  @override
  dynamic getAppBar(BuildContext context) => "Login Page";

  @override
  Widget getBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Welcome to Auth Flow", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: interactor.onLoginPressed, 
            child: const Text("LOGIN SUCCESS (Simulate)")
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: interactor.onRegisterPressed, 
            child: const Text("Create an account")
          ),
          TextButton(
            onPressed: interactor.onForgotPwPressed, 
            child: const Text("Forgot your password?")
          ),
        ],
      ),
    );
  }
}
