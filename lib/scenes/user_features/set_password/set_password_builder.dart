/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 17:35
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_features/set_password/interactor/set_password_interactor.dart';
import 'package:coffee_bean/scenes/user_features/set_password/interactor/set_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- ROUTE ---
class SetPasswordCompleteRoute implements DbNoteRoute {}

// --- BUILDER & ROUTER ---
class SetPasswordBuilder extends DbNoteRouter implements DbNoteBuilder<SetPasswordBuilder> {

  SetPasswordBuilder();

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // if (toRoute is SetPasswordCompleteRoute) {
    //   navigator.pop(fromContext: fromContext);
    // }

    // Day toan bo cho router cha xu ly
    parentRouter?.navigate(toRoute, fromContext: fromContext, routeName: routeName, parameters: parameters);
  }

  @override
  SetPasswordBuilder build() {
    final interactor = SetPasswordInteractor(router: this);
    final page = SetPasswordPage(interactor: interactor);
    attach(interactor, page);
    return this;
  }


}
