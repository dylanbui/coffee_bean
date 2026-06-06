// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// Author: dylanbui
// Create Date: 2026-06-05
// Description: [Add a brief description of the file's purpose]
//
// Copyright (c) 2026. All rights reserved.
// **************************************************************************
import 'package:coffee_bean/scenes/point_features/point_task/interactor/point_task_interactor.dart';
import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/point_features/point_task/interactor/point_task_page.dart';
import 'package:flutter/material.dart';

// ROUTE
abstract class PointTaskFirstRoute implements DbNoteRoute {}

// ROUTABLE
abstract class PointTaskRoutable implements DbNoteRoutable {}

// -- ROUTER --
class PointTaskRouter extends DbNoteRouter implements PointTaskRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {}
}


// -- BUILDER --
class PointTaskBuilder extends DbNoteBuilder<PointTaskRouter> {
  @override
  PointTaskRouter build() {
    final router = PointTaskRouter();
    final interactor = PointTaskInteractor(router);
    final page = PointTaskPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
