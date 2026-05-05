/*
 * Created with Android Studio
 * Package: coffee bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 18:59
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/architecture_ribs/navigator.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_pages/privacy_policy/privacy_policy_builder.dart';
import 'package:coffee_bean/scenes/user_pages/user_agreement/user_agreement_builder.dart';
import 'package:coffee_bean/scenes/user_pages/user_register/interactor/user_register_interactor.dart';
import 'package:coffee_bean/scenes/user_pages/user_register/interactor/user_register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- LISTENER ---
// Defines the "contract" that the parent module must implement to receive notifications
// when this splash module completes.


// --- ROUTE ---
// A Route object to communicate the "completion" event from the Interactor to the Builder/Router.
class UserRegisterCompleteRoute implements DbNoteRoute {}
class UserLoginRoute implements DbNoteRoute {}

class UserAgreementRoute implements DbNoteRoute {}
class PrivacyPolicyRoute implements DbNoteRoute {}


// --- BUILDER ---
// Responsible for initializing the Interactor, Page, and connecting them.
class UserRegisterBuilder extends DbNoteBuilder with DbNavigator implements DbNoteRoutable {

  UserRegisterBuilder();

  @override
  Widget build() {
    // The Interactor (Cubit) is created here. It receives a reference to the router (which is 'this').
    final interactor = UserRegisterInteractor(router: this);
    final page = UserRegisterPage();

    // BlocProvider "injects" the Cubit into the widget tree, making it accessible to the Page.
    rootPage = BlocProvider<UserRegisterInteractor>.value(value: interactor, child: page);
    return rootPage;
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is UserRegisterCompleteRoute) {
      // When the completion route is received, notify the parent module's listener.

    } else if (toRoute is UserLoginRoute) {
      pop();

    } else if (toRoute is UserAgreementRoute) {
      UserAgreementBuilder userAgreementBuilder = UserAgreementBuilder();
      push(userAgreementBuilder.build());

    } else if (toRoute is PrivacyPolicyRoute) {
      PrivacyPolicyBuilder privacyPolicyBuilder = PrivacyPolicyBuilder();
      push(privacyPolicyBuilder.build());

    }
  }
}



