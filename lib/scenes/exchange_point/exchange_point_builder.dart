// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// Author: dylanbui
// Create Date: 2026-06-05
// Description: [Add a brief description of the file's purpose]
//
// Copyright (c) 2026. All rights reserved.
// **************************************************************************
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/exchange_point/interactor/exchange_point_interactor.dart';
import 'package:coffee_bean/scenes/exchange_point/interactor/exchange_point_page.dart';
import 'package:flutter/material.dart';

// ROUTE
abstract class ExchangePointFirstRoute implements DbNoteRoute {}

// ROUTABLE
abstract class ExchangePointRoutable implements DbNoteRoutable {}

// -- ROUTER --
class ExchangePointRouter extends DbNoteRouter implements ExchangePointRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {}
}


// -- BUILDER --
class ExchangePointBuilder extends DbNoteBuilder<ExchangePointRouter> {
  @override
  ExchangePointRouter build() {
    final router = ExchangePointRouter();
    final interactor = ExchangePointInteractor(router);
    final page = ExchangePointPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
