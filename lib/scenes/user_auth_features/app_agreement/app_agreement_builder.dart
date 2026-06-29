/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 */

import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/app_agreement/interactor/app_agreement_interactor.dart';
import 'package:coffee_bean/scenes/user_auth_features/app_agreement/interactor/app_agreement_page.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

abstract class AppAgreementRoutable implements DbNoteRoutable {

}

class AppAgreementRouter extends DbNoteRouter implements AppAgreementRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
  }
}



class AppAgreementBuilder extends DbNoteBuilder<AppAgreementRouter> {
  final int type;
  final String title;

  AppAgreementBuilder({required this.type, required this.title});

  @override
  AppAgreementRouter build() {
    final router = AppAgreementRouter();
    final interactor = AppAgreementInteractor(router: router, type: type);
    final page = AppAgreementPage(interactor: interactor, initialTitle: title);
    router.attach(interactor, page);
    return router;
  }

}
