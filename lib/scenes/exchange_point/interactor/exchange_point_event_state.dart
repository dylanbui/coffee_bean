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

class ExchangePointItem {
  final String title;
  final String caption;
  final String buttonText;
  final String action;

  ExchangePointItem({
    required this.title,
    required this.caption,
    required this.buttonText,
    required this.action,
  });
}

// STATES
abstract class ExchangePointState extends BaseBlocState {
  final List<ExchangePointItem> items;
  ExchangePointState({this.items = const []});
}

class ExchangePointInitial extends ExchangePointState {}

class ExchangePointLoading extends ExchangePointState {}

class ExchangePointSuccess extends ExchangePointState {
  ExchangePointSuccess(List<ExchangePointItem> items) : super(items: items);
}
