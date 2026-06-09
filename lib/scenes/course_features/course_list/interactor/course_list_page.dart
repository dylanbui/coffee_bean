// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// File: course_list_page.dart
// Author: dylanbui
// Create Date: 2026-06-09
// Description: [Add a brief description of the file's purpose]
//
// Copyright (c) 2026. All rights reserved.
// **************************************************************************
import 'package:coffee_bean/scenes/course_features/course_list/interactor/course_list_event_state.dart';
import 'package:coffee_bean/scenes/course_features/course_list/interactor/course_list_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class CourseListPage extends AppCubitStateFulWidget<CourseListInteractor, CourseListState> {
  CourseListPage({super.key, required super.interactor});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends AppCubitState<CourseListPage, CourseListInteractor, CourseListState> {

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: getBody(context),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return const SizedBox(width: 16);
  }

}