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
import 'package:coffee_bean/scenes/rib_samples/auth_flow_sample/auth_flow_rib.dart';
import 'package:flutter/material.dart';

// --- STATE ---
class ForgotPwState extends BaseBlocState {}

// --- INTERACTOR ---
class ForgotPwInteractor extends CubitInteractor<ForgotPwRouter, ForgotPwState> {
  ForgotPwInteractor(ForgotPwRouter router) : super(ForgotPwState(), router: router);

  void onResetSuccess() => router?.parentRouter?.navigate(AuthSuccessResultRoute("TOKEN_RESET_789"));
}

// --- ROUTER ---
class ForgotPwRouter extends DbNoteRouter {}

// --- BUILDER ---
class ForgotPwBuilder extends DbNoteBuilder<ForgotPwRouter> {
  @override
  ForgotPwRouter build() {
    final router = ForgotPwRouter();
    final interactor = ForgotPwInteractor(router);
    final page = ForgotPwPage(interactor: interactor);
    
    router.attach(interactor, page);
    return router;
  }
}

// --- PAGE ---
class ForgotPwPage extends CubitStateFulWidget<ForgotPwInteractor, ForgotPwState> {
  ForgotPwPage({super.key, required super.interactor});

  @override
  State<ForgotPwPage> createState() => _ForgotPwPageState();
}

class _ForgotPwPageState extends CubitState<ForgotPwPage, ForgotPwInteractor, ForgotPwState> {
  @override
  dynamic getAppBar(BuildContext context) => "Forgot Password";

  @override
  Widget getBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_reset, size: 80, color: Colors.orange),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text("Enter your email to receive instructions to reset your password", textAlign: TextAlign.center),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: interactor.onResetSuccess, 
            child: const Text("SEND RESET EMAIL")
          ),
        ],
      ),
    );
  }
}
