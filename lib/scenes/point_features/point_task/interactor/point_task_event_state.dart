// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// Author: dylanbui
// Create Date: 2026-06-05
// Description: [Add a brief description of the file's purpose]
//
// Copyright (c) 2026. All rights reserved.
// **************************************************************************
import 'package:db_core/state_management/lib_bloc/constants.dart';

class PointTaskItem {
  final String title;
  final String caption;
  final String buttonText;
  final String action;

  PointTaskItem({
    required this.title,
    required this.caption,
    required this.buttonText,
    required this.action,
  });
}

// STATES
abstract class PointTaskState extends BaseBlocState {
  final List<PointTaskItem> items;
  PointTaskState({this.items = const []});
}

class PointTaskInitial extends PointTaskState {}

class PointTaskLoading extends PointTaskState {}

class PointTaskSuccess extends PointTaskState {
  PointTaskSuccess(List<PointTaskItem> items) : super(items: items);
}
