// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// File: daily_sign_in_page.dart
// Author: dylanbui
// Create Date: 2026-06-06
// Description: Daily check-in page to receive reward points
//
// Copyright (c) 2026. All rights reserved.
// **************************************************************************
import 'package:coffee_bean/data/local/user_manager/user_manager.dart';
import 'package:coffee_bean/scenes/point_features/daily_sign_in/interactor/daily_sign_in_event_state.dart';
import 'package:coffee_bean/scenes/point_features/daily_sign_in/interactor/daily_sign_in_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_sliver_app_bar.dart';
import 'package:coffee_bean/utils/flash_utils/flash_toast_helper.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class DailySignInPage extends AppCubitStateFulWidget<DailySignInInteractor, DailySignInState> {
  DailySignInPage({super.key, required super.interactor});

  @override
  State<DailySignInPage> createState() => _DailySignInPageState();
}

class _DailySignInPageState extends AppCubitState<DailySignInPage, DailySignInInteractor, DailySignInState> {
  @override
  Widget buildScaffold(BuildContext context, PreferredSizeWidget? appBar, Widget body) {
    return Scaffold(backgroundColor: Colors.white, appBar: appBar, body: body);
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<DailySignInInteractor, DailySignInState>(
      bloc: interactor,
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            CoffeeSliverAppBar(
              imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=2070&auto=format&fit=crop',
              expandedHeight: 300,
              pinned: false,
              style: TmLabAppBarStyle.transparentStyle.copyWith(foregroundColor: Colors.white),
              onBackTap: () => interactor.router?.pop(),
            ),
// ... tiếp tục phần code cũ ...

            // Main Content
            SliverToBoxAdapter(
              child: Container(
                transform: Matrix4.translationValues(0, -30, 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          _buildUserCard(state),
                          const SizedBox(height: 20),
                          Text("Điểm danh nhận điểm tích lũy", style: TMLabsTextStyle.title.copyWith(fontSize: 18)),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      _buildCheckInGrid(state),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          _buildCheckInButton(state),
                          const SizedBox(height: 16),
                          Text("Quy tắc điểm danh", style: TMLabsTextStyle.title.copyWith(fontSize: 18)),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      _buildRulesSection(),
                      const SizedBox(height: 10),
                      _buildRulesSection(),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserCard(DailySignInState state) {
    final userInfo = UserManager().userInfo;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TMLabsColor.bgMain,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(userInfo?.avatar ?? 'https://i.pravatar.cc/150?u=a042581f4e29026704d'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.secondary),
                    children: [
                      TextSpan(text: userInfo?.nickname ?? "Bạn"),
                      const TextSpan(text: " đã điểm danh liên tiếp "),
                      TextSpan(text: "${state.streakDays} ngày", style: TMLabsTextStyle.bodyBold),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
                    children: [
                      const TextSpan(text: "Hôm nay điểm danh có thể nhận "),
                      TextSpan(
                        text: "${state.todayPoints} điểm",
                        style: TMLabsTextStyle.caption.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInGrid(DailySignInState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: state.checkInHistory.map((item) => _buildCheckInItem(item)).toList(),
    );
  }

  Widget _buildCheckInItem(CheckInItem item) {
    Decoration decoration;
    Color dateColor = TMLabsColor.grey;
    Color pointColor = TMLabsColor.primary;
    Color labelColor = TMLabsColor.grey;
    bool isBoldLabel = false;
    double coinOpacity = 0.5;

    if (item.isToday) {
      decoration = BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFE8A4), Color(0xFFFDBB4E)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: const Color(0xFFFDBB4E).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      );
      dateColor = TMLabsColor.grey.withValues(alpha: 0.8);
      pointColor = const Color(0xFFBF360C); // Màu đỏ cam đậm cho số điểm ngày hiện tại
      labelColor = TMLabsColor.primary;
      isBoldLabel = true;
      coinOpacity = 1.0;
    } else if (item.isFuture) {
      decoration = BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF7DC), Color(0xFFF3C358)],
        ),
        borderRadius: BorderRadius.circular(12),
      );
      dateColor = TMLabsColor.grey.withValues(alpha: 0.6);
      pointColor = const Color(0xFFF57C00); // Màu cam cho tương lai
      labelColor = TMLabsColor.grey.withValues(alpha: 0.6);
    } else {
      decoration = BoxDecoration(
        color: const Color(0xFFEEEDEE), // Xám nhạt cho quá khứ
        borderRadius: BorderRadius.circular(12),
      );
      dateColor = TMLabsColor.grey.withValues(alpha: 0.6);
      pointColor = TMLabsColor.grey;
      labelColor = TMLabsColor.grey.withValues(alpha: 0.6);
    }

    return Container(
      width: (MediaQuery.of(context).size.width - 40 - 36) / 7,
      height: 125,
      decoration: decoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(item.dateLabel, style: TMLabsTextStyle.caption.copyWith(color: dateColor, fontSize: 11)),
          Text(item.pointLabel, style: TMLabsTextStyle.bodyBold.copyWith(color: pointColor, fontSize: 15)),
          Opacity(
            opacity: coinOpacity,
            child: AppIcon(
              item.isChecked || item.isFuture || item.isToday ? AppAssets.icons.icGoldCoin : AppAssets.icons.icGrayCoin,
              size: 28,
            ),
          ),
          Text(
            item.isToday
                ? (item.isChecked ? "Đã điểm danh" : "Hôm nay")
                : (item.isChecked ? "Đã điểm danh" : (item.isPast ? "Chưa điểm danh" : "Chờ điểm danh")),
            textAlign: TextAlign.center,
            style: TMLabsTextStyle.small.copyWith(
              fontSize: 9,
              color: labelColor,
              fontWeight: isBoldLabel ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInButton(DailySignInState state) {
    if (state.alreadyCheckedInToday) {
      return AppButton(
        text: "Hôm nay đã điểm danh, mai quay lại nhé.",
        onPressed: null, // Disable button
        style: TMLabsButtonStyle.primary.copyWith(
          backgroundColor: TMLabsColor.lightGrey.withValues(alpha: 0.3),
          textColor: TMLabsColor.grey,
        ),
      );
    }

    return AppButton(
      text: "Điểm danh",
      onPressed: () => interactor.checkIn(),
      isLoading: state is DailySignInLoading,
      style: TMLabsButtonStyle.primary,
    );
  }

  Widget _buildRulesSection() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TMLabsColor.lightGrey.withValues(alpha: 0.5)),
      ),
      child: Center(
        child: Text(
          "Giới thiệu quy tắc cố định bằng hình ảnh",
          textAlign: TextAlign.center,
          style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
        ),
      ),
    );
  }
}
