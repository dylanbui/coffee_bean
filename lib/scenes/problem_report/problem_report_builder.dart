/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 29/4/26 - 16:15
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/problem_report/interactor/problem_report_interactor.dart';
import 'package:coffee_bean/scenes/problem_report/interactor/problem_report_page.dart';
import 'package:coffee_bean/scenes/problem_report/problem_report_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ProblemReportBuilder extends DbNoteBuilder {
    @override
    Widget buildFactory() {
        final router = ProblemReportRouter();
        final problemReportInteractor = ProblemReportInteractor(router);
        final page = ProblemReportPage();
        return BlocProvider(create: (_) =>  problemReportInteractor, child: page,);
    }



}