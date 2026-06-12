/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 17:35
 * To change this template use File | Settings | File Templates.
 */

import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_auth_features/set_password/interactor/set_password_interactor.dart';
import 'package:coffee_bean/scenes/user_auth_features/set_password/interactor/set_password_page.dart';
import 'package:flutter/material.dart';

// --- ROUTE ---
class SetPasswordCompleteRoute implements DbNoteRoute {}

// --- BUILDER & ROUTER ---
class SetPasswordBuilder extends DbNoteSimpleRouterBuilder {
  final String mobile;
  final String code;

  SetPasswordBuilder({required this.mobile, required this.code});

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // Day toan bo cho router cha xu ly
    parentRouter?.navigate(toRoute, fromContext: fromContext, routeName: routeName, parameters: parameters);
  }

  @override
  SetPasswordBuilder build() {
    final interactor = SetPasswordInteractor(mobile: mobile, code: code, router: this);
    final page = SetPasswordPage(interactor: interactor);
    attach(interactor, page);
    return this;
  }
}
