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
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/data/local/user_manager/user_manager_events.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/point_features/daily_sign_in/daily_sign_in_builder.dart';
import 'package:coffee_bean/scenes/point_features/daily_sign_in/interactor/daily_sign_in_event_state.dart';
import 'package:coffee_bean/shared/service/system_notify/system_notify_event.dart';
import 'package:db_core/db_core.dart';

// INTERACTOR
class DailySignInInteractor extends CubitInteractor<DailySignInRoutable, DailySignInState> {
  final UserRepository _userRepo = locator<UserRepository>();

  DailySignInInteractor(DailySignInRoutable router) : super(DailySignInInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    loadData();
  }

  Future<void> loadData() async {
    emit(DailySignInLoading(state));

    // Lấy song song cấu hình điểm thưởng và tóm tắt lịch sử điểm danh của user
    final results = await Future.wait([
      _userRepo.getSignInConfigList(),
      _userRepo.getSignInRecordSummary(),
    ]);

    // Xử lý kết quả trả về bằng Pattern Matching
    if ((results[0], results[1]) case (DbSuccess<List<Dictionary>>(data: final configList), DbSuccess<Dictionary>(data: final summary))) {
      final int continuousDay = summary['continuousDay'] as int? ?? 0;
      final bool todaySignIn = summary['todaySignIn'] as bool? ?? false;
      
      // Đồng bộ trạng thái điểm danh local nếu server báo đã điểm danh
      if (todaySignIn) {
        await UserManager().saveLastSignInDate();
      }
      
      // Chuyển configList sang Map {day: point} để tra cứu nhanh điểm thưởng theo số ngày liên tiếp
      final Map<int, int> configMap = {
        for (var item in configList) 
          (item['day'] as int? ?? 0): (item['point'] as int? ?? 0)
      };

      final now = DateTime.now();
      final List<CheckInItem> history = [];

      // Xây dựng Grid 7 ngày hiển thị xung quanh ngày hiện tại: [T-3, T-2, T-1, T, T+1, T+2, T+3]
      // Xác định "chỉ số ngày" (sIdx) của hôm nay trong chuỗi điểm danh.
      // Nếu hôm nay đã điểm danh, sIdx là continuousDay. Nếu chưa, sIdx là ngày tiếp theo (continuousDay + 1).
      final int todaySIdx = todaySignIn ? continuousDay : continuousDay + 1;

      for (int i = -3; i <= 3; i++) {
        final date = now.add(Duration(days: i));
        final sIdx = todaySIdx + i; // Chỉ số ngày tương ứng trong cấu hình thưởng
        final points = configMap[sIdx] ?? 0;

        bool isChecked = false;
        if (i < 0) {
          // Các ngày quá khứ: đã check nếu sIdx nằm trong chuỗi liên tiếp hiện tại
          isChecked = sIdx > 0 && sIdx <= continuousDay;
        } else if (i == 0) {
          // Ngày hiện tại: dựa vào trạng thái todaySignIn từ server
          isChecked = todaySignIn;
        }

        history.add(CheckInItem(
          dateLabel: "${date.day}/${date.month}",
          pointLabel: points > 0 ? "+$points" : "/",
          isToday: i == 0,
          isPast: i < 0,
          isFuture: i > 0,
          isChecked: isChecked,
        ));
      }

      emit(DailySignInSuccess(
        checkInHistory: history,
        streakDays: continuousDay,
        todayPoints: configMap[todaySIdx] ?? 0,
        alreadyCheckedInToday: todaySignIn,
      ));
    } else {
      // Trường hợp lỗi API: Bắn thông báo hệ thống và giữ nguyên data cũ, chỉ tắt loading
      locator<DbEventBus>().fire(SystemErrorNotifyEvent("Không thể tải dữ liệu điểm danh"));
      emit(DailySignInSuccess(
        checkInHistory: state.checkInHistory,
        streakDays: state.streakDays,
        todayPoints: state.todayPoints,
        alreadyCheckedInToday: state.alreadyCheckedInToday,
      ));
    }
  }

  Future<void> checkIn() async {
    if (state.alreadyCheckedInToday) return;

    emit(DailySignInLoading(state));

    final result = await _userRepo.createSignInRecord();

    if (result case DbSuccess()) {
      // 1. Đồng bộ trạng thái điểm danh local
      await UserManager().saveLastSignInDate();

      // 2. Lấy lại userInfo mới để cập nhật điểm trên UI đồng bộ toàn hệ thống
      final infoRes = await _userRepo.getUserInfo();
      if (infoRes case DbSuccess(:final data)) {
        await UserManager().saveUserInfo(data);
        locator<DbEventBus>().fire(UserInfoUpdatedEvent(data));
      }

      // 2. Bắn thông báo thành công qua EventBus
      locator<DbEventBus>().fire(SystemSuccessNotifyEvent("Điểm danh thành công!"));

      // 3. Cập nhật state tạm thời (Instant UI) trước khi loadData
      emit(DailySignInSuccess(
        checkInHistory: state.checkInHistory,
        streakDays: state.streakDays,
        todayPoints: state.todayPoints,
        alreadyCheckedInToday: true,
      ));
      
      await loadData(); // Refresh data từ server
    } else if (result case DbFailure(error: final error)) {
      locator<DbEventBus>().fire(SystemErrorNotifyEvent(error.message));
      emit(DailySignInSuccess(
        checkInHistory: state.checkInHistory,
        streakDays: state.streakDays,
        todayPoints: state.todayPoints,
        alreadyCheckedInToday: state.alreadyCheckedInToday,
      ));
    }
  }
}
