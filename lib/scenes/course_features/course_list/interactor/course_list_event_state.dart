// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// File: course_list_event_state.dart
// Author: dylanbui
// Create Date: 2026-06-09
// Description: [Add a brief description of the file's purpose]
//
// Copyright (c) 2026. All rights reserved.
// **************************************************************************
import 'package:db_core/state_management/lib_bloc/constants.dart';

// STATES
abstract class CourseListState extends BaseBlocState {}

class CourseListInitial extends CourseListState {}

class CourseListLoading extends CourseListState {}

class CourseListSuccess extends CourseListState {}