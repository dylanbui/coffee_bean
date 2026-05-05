/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 14:24
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/architecture_ribs/navigator.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_pages/privacy_policy/interactor/privacy_policy_interactor.dart';
import 'package:coffee_bean/scenes/user_pages/privacy_policy/interactor/privacy_policy_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- ROUTE ---
// A Route object to communicate the "completion" event from the Interactor to the Builder/Router.
class PrivacyPolicyCompleteRoute implements DbNoteRoute {}

// --- BUILDER ---
// Responsible for initializing the Interactor, Page, and connecting them.
class PrivacyPolicyBuilder extends DbNoteBuilder with DbNavigator implements DbNoteRoutable {

  PrivacyPolicyBuilder();

  @override
  Widget build() {
    // The Interactor (Cubit) is created here. It receives a reference to the router (which is 'this').
    final interactor = PrivacyPolicyInteractor(router: this);
    final page = PrivacyPolicyPage();

    // BlocProvider "injects" the Cubit into the widget tree, making it accessible to the Page.
    rootPage = BlocProvider<PrivacyPolicyInteractor>.value(value: interactor, child: page);
    return rootPage;
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is PrivacyPolicyCompleteRoute) {
    }
  }
}



