// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// File: course_list_interactor.dart
// Author: dylanbui
// Create Date: 2026-06-09
// Description: [Add a brief description of the file's purpose]
//
// Copyright (c) 2026. All rights reserved.
// **************************************************************************
import 'package:coffee_bean/scenes/course_features/course_list/course_list_builder.dart';
import 'package:coffee_bean/scenes/course_features/course_list/interactor/course_list_event_state.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';

// INTERACTOR
class CourseListInteractor extends CubitInteractor<CourseListRoutable, CourseListState> {
  CourseListInteractor(CourseListRoutable router) : super(CourseListInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    // Load initial profile data
  }
}
