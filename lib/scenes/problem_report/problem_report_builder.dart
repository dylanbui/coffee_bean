/*
 * Created with IntelliJ IDEA
 * Package:
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 29/4/26 - 16:15
 * To change this template use File | Settings | File Templates.
 */

import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/scenes/problem_report/interactor/problem_report_interactor.dart';
import 'package:coffee_bean/scenes/problem_report/interactor/problem_report_page.dart';
import 'package:flutter/material.dart';

// --- Router Section ---

// Route
class ProblemReportDoneRoute implements DbNoteRoute {
  final int reportId;
  ProblemReportDoneRoute(this.reportId);
}

// Router
class ProblemReportRouter extends DbNoteRouter {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ProblemReportDoneRoute) {
      // Implementation for navigating to or within Problem Report completion
    }
  }
}

// --- Builder Section ---

class ProblemReportBuilder extends DbNoteBuilder<ProblemReportRouter> {
  @override
  ProblemReportRouter build() {
    final router = ProblemReportRouter();
    final interactor = ProblemReportInteractor(router);
    final page = ProblemReportPage(interactor: interactor);
    router.attach(interactor, page);
    return router;
  }
}
