/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 14:14
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/user_pages/user_agreement/interactor/user_agreement_interactor.dart';
import 'package:coffee_bean/scenes/user_pages/user_agreement/interactor/user_agreement_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- ROUTE ---
class UserAgreementCompleteRoute implements DbNoteRoute {}

// --- BUILDER & ROUTER ---
class UserAgreementBuilder extends DbNoteRouter implements DbNoteBuilder<UserAgreementBuilder> {

  UserAgreementBuilder();

  @override
  UserAgreementBuilder build() {
    final interactor = UserAgreementInteractor(router: this);
    final page = UserAgreementPage(interactor: interactor);

    attach(interactor, BlocProvider<UserAgreementInteractor>.value(value: interactor, child: page));

    return this;
  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is UserAgreementCompleteRoute) {
      navigator.pop(fromContext: fromContext);
    }
  }
}
