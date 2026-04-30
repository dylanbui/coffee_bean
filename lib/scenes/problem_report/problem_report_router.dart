/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 29/4/26 - 16:15
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';


// Route
class ProblemReportDoneRoute implements DbNoteRoute {
    int reportId;
    ProblemReportDoneRoute(this.reportId);
}

// Router
class ProblemReportRouter extends DbNoteRouter {

    @override
    void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
        if (toRoute is ProblemReportDoneRoute) {
            // Implementation for navigating to or within Product Detail
        }
    }

}