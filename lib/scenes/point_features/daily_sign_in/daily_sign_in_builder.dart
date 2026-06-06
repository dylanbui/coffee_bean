// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// File: daily_sign_in_builder.dart
// Author: dylanbui
// Create Date: 2026-06-06
// Description: [Add a brief description of the file's purpose]
//
// Copyright (c) 2026. All rights reserved.
// **************************************************************************
import 'package:coffee_bean/scenes/point_features/daily_sign_in/interactor/daily_sign_in_interactor.dart';
import 'package:coffee_bean/scenes/point_features/daily_sign_in/interactor/daily_sign_in_page.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

// ROUTE
abstract class DailySignInPageStateFirstRoute implements DbNoteRoute {}

// ROUTABLE
abstract class DailySignInRoutable implements DbNoteRoutable {}

// -- ROUTER --
class DailySignInRouter extends DbNoteRouter implements DailySignInRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {}
}


// -- BUILDER --
class DailySignInBuilder extends DbNoteBuilder<DailySignInRouter> {
  @override
  DailySignInRouter build() {
    final router = DailySignInRouter();
    final interactor = DailySignInInteractor(router);
    final page = DailySignInPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
