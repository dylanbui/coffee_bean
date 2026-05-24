/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 */

import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/scenes/rib_samples/auth_flow_sample/auth_flow_rib.dart';
import 'package:flutter/material.dart';

// --- STATE ---
class RegisterState extends BaseBlocState {}

// --- INTERACTOR ---
class RegisterInteractor extends CubitInteractor<RegisterRouter, RegisterState> {
  RegisterInteractor(RegisterRouter router) : super(RegisterState(), router: router);

  void onRegisterComplete() => router?.parentRouter?.navigate(AuthSuccessResultRoute("TOKEN_REG_456"));
}

// --- ROUTER ---
class RegisterRouter extends DbNoteRouter {}

// --- BUILDER ---
class RegisterBuilder extends DbNoteBuilder<RegisterRouter> {
  @override
  RegisterRouter build() {
    final router = RegisterRouter();
    final interactor = RegisterInteractor(router);
    final page = RegisterPage(interactor: interactor);
    
    router.attach(interactor, page);
    return router;
  }
}

// --- PAGE ---
class RegisterPage extends CubitStateFulWidget<RegisterInteractor, RegisterState> {
  RegisterPage({super.key, required super.interactor});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends CubitState<RegisterPage, RegisterInteractor, RegisterState> {
  @override
  dynamic getAppBar(BuildContext context) => "Register Account";

  @override
  Widget getBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_add, size: 80, color: Colors.blue),
          const SizedBox(height: 20),
          const Text("Join our coffee community"),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: interactor.onRegisterComplete, 
            child: const Text("FINISH REGISTRATION")
          ),
        ],
      ),
    );
  }
}
