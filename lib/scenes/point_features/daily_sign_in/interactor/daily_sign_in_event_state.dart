// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// File: daily_sign_in_event_state.dart
// Author: dylanbui
// Create Date: 2026-06-06
// Description: [Add a brief description of the file's purpose]
//
// Copyright (c) 2026. All rights reserved.
// **************************************************************************
import 'package:db_core/state_management/lib_bloc/constants.dart';

class CheckInItem {
  final String dateLabel; // e.g., "5/1"
  final String pointLabel; // e.g., "+7"
  final bool isToday;
  final bool isPast;
  final bool isChecked;
  final bool isFuture;

  CheckInItem({
    required this.dateLabel,
    required this.pointLabel,
    this.isToday = false,
    this.isPast = false,
    this.isChecked = false,
    this.isFuture = false,
  });
}

// STATES
abstract class DailySignInState extends BaseBlocState {
  final List<CheckInItem> checkInHistory;
  final int streakDays;
  final int todayPoints;
  final bool alreadyCheckedInToday;

  DailySignInState({
    this.checkInHistory = const [],
    this.streakDays = 0,
    this.todayPoints = 0,
    this.alreadyCheckedInToday = false,
  });

  @override
  List<Object?> get props => [
        checkInHistory,
        streakDays,
        todayPoints,
        alreadyCheckedInToday,
      ];
}

class DailySignInInitial extends DailySignInState {
  DailySignInInitial() : super();
}

class DailySignInLoading extends DailySignInState {
  DailySignInLoading(DailySignInState state)
      : super(
          checkInHistory: state.checkInHistory,
          streakDays: state.streakDays,
          todayPoints: state.todayPoints,
          alreadyCheckedInToday: state.alreadyCheckedInToday,
        );
}

class DailySignInSuccess extends DailySignInState {
  DailySignInSuccess({
    required super.checkInHistory,
    required super.streakDays,
    required super.todayPoints,
    required super.alreadyCheckedInToday,
  });
}
