/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 14:24
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_pages/privacy_policy/interactor/privacy_policy_interactor.dart';
import 'package:coffee_bean/scenes/user_pages/privacy_policy/interactor/privacy_policy_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- ROUTE ---
class PrivacyPolicyCompleteRoute implements DbNoteRoute {}

// --- BUILDER & ROUTER ---
class PrivacyPolicyBuilder extends DbNoteRouter implements DbNoteBuilder<PrivacyPolicyBuilder> {

  PrivacyPolicyBuilder();

  @override
  PrivacyPolicyBuilder build() {
    final interactor = PrivacyPolicyInteractor(router: this);
    final page = PrivacyPolicyPage(interactor: interactor);

    attach(interactor, BlocProvider<PrivacyPolicyInteractor>.value(value: interactor, child: page));

    return this;
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is PrivacyPolicyCompleteRoute) {
      // Handle completion
    }
  }
}
