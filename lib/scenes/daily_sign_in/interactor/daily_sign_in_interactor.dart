// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// File: daily_sign_in_interactor.dart
// Author: dylanbui
// Create Date: 2026-06-06
// Description: [Add a brief description of the file's purpose]
//
// Copyright (c) 2026. All rights reserved.
// **************************************************************************
import 'package:coffee_bean/scenes/daily_sign_in/interactor/daily_sign_in_event_state.dart';
import 'package:coffee_bean/scenes/daily_sign_in/daily_sign_in_builder.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';

// INTERACTOR
class DailySignInInteractor extends CubitInteractor<DailySignInRoutable, DailySignInState> {
  DailySignInInteractor(DailySignInRoutable router) : super(DailySignInInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    loadData();
  }

  void loadData() {
    emit(DailySignInLoading(state));
    
    // Mock data based on design
    final List<CheckInItem> mockHistory = [
      CheckInItem(dateLabel: "5/1", pointLabel: "+7", isPast: true, isChecked: true),
      CheckInItem(dateLabel: "6/1", pointLabel: "/", isPast: true, isChecked: false),
      CheckInItem(dateLabel: "7/1", pointLabel: "+1", isPast: true, isChecked: true),
      CheckInItem(dateLabel: "5/1", pointLabel: "+2", isToday: true, isChecked: false),
      CheckInItem(dateLabel: "6/1", pointLabel: "+3", isFuture: true),
      CheckInItem(dateLabel: "7/1", pointLabel: "+4", isFuture: true),
      CheckInItem(dateLabel: "7/1", pointLabel: "+5", isFuture: true),
    ];

    emit(DailySignInSuccess(
      checkInHistory: mockHistory,
      streakDays: 1,
      todayPoints: 2,
      alreadyCheckedInToday: false,
    ));
  }

  void checkIn() {
    if (state.alreadyCheckedInToday) return;

    emit(DailySignInLoading(state));
    
    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      final updatedHistory = state.checkInHistory.map((item) {
        if (item.isToday) {
          return CheckInItem(
            dateLabel: item.dateLabel,
            pointLabel: item.pointLabel,
            isToday: true,
            isChecked: true,
          );
        }
        return item;
      }).toList();

      emit(DailySignInSuccess(
        checkInHistory: updatedHistory,
        streakDays: state.streakDays + 1,
        todayPoints: state.todayPoints,
        alreadyCheckedInToday: true,
      ));
    });
  }
}
