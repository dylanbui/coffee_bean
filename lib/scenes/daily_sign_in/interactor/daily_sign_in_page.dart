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
import 'package:coffee_bean/scenes/daily_sign_in/interactor/daily_sign_in_event_state.dart';
import 'package:coffee_bean/scenes/daily_sign_in/interactor/daily_sign_in_interactor.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui_control/coffee_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class DailySignInPage extends AppCubitStateFulWidget<DailySignInInteractor, DailySignInState> {
  DailySignInPage({super.key, required super.interactor});

  @override
  State<DailySignInPage> createState() => _DailySignInPageState();
}

class _DailySignInPageState
    extends AppCubitState<DailySignInPage, DailySignInInteractor, DailySignInState> {
  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      backgroundColor: TMLabsColor.bgMain,
      body: getBody(context),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<DailySignInInteractor, DailySignInState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            CoffeeSliverAppBar(
              imageUrl:
                  'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=2070&auto=format&fit=crop',
              expandedHeight: 300,
              pinned: true,
              style: TmLabAppBarStyle.transparentStyle.copyWith(
                foregroundColor: Colors.white,
              ),
              onBackTap: () => Navigator.of(context).pop(),
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Container(
                transform: Matrix4.translationValues(0, -30, 0),
                decoration: const BoxDecoration(
                  color: TMLabsColor.bgMain,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildUserCard(state),
                      const SizedBox(height: 30),
                      Text(
                        "Điểm danh nhận điểm tích lũy",
                        style: TMLabsTextStyle.title.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      _buildCheckInGrid(state),
                      const SizedBox(height: 30),
                      _buildCheckInButton(state),
                      const SizedBox(height: 40),
                      Text(
                        "Quy tắc điểm danh",
                        style: TMLabsTextStyle.title.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TMLabsColor.bgLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'),
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
                      const TextSpan(text: "Bạn đã điểm danh liên tiếp "),
                      TextSpan(
                        text: "${state.streakDays} ngày",
                        style: TMLabsTextStyle.bodyBold,
                      ),
                    ],
                  ),
                ),
                Text(
                  "Hôm nay điểm danh có thể nhận ${state.todayPoints} điểm",
                  style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.grey),
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
    Color textColor = TMLabsColor.grey;

    if (item.isToday) {
      decoration = BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFE082), Color(0xFFFFD54F)],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD54F).withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      );
      textColor = TMLabsColor.primary;
    } else if (item.isFuture) {
      decoration = BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF9C4), Color(0xFFFFF59D)],
        ),
        borderRadius: BorderRadius.circular(10),
      );
      textColor = TMLabsColor.primary.withValues(alpha: 0.5);
    } else {
      decoration = BoxDecoration(
        color: const Color(0xFFE8E8E8), // Light gray for past
        borderRadius: BorderRadius.circular(10),
      );
      textColor = TMLabsColor.grey.withValues(alpha: 0.6);
    }

    return Container(
      width: (MediaQuery.of(context).size.width - 40 - 30) / 7,
      height: 110,
      decoration: decoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            item.dateLabel,
            style: TMLabsTextStyle.caption.copyWith(color: textColor, fontWeight: FontWeight.w600),
          ),
          Text(
            item.pointLabel,
            style: TMLabsTextStyle.bodyBold.copyWith(color: textColor),
          ),
          AppIcon(
            item.isChecked ? AppAssets.icons.icGoldCoin : AppAssets.icons.icGrayCoin,
            size: 24,
          ),
          if (item.isToday)
            Text(
              "Hôm nay",
              style: TMLabsTextStyle.small.copyWith(color: TMLabsColor.primary),
            )
          else
            Text(
              item.isChecked ? "Đã điểm danh" : (item.isPast ? "Chưa điểm danh" : "Chờ điểm danh"),
              textAlign: TextAlign.center,
              style: TMLabsTextStyle.small.copyWith(
                fontSize: 8,
                color: textColor.withValues(alpha: 0.7),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCheckInButton(DailySignInState state) {
    if (state.alreadyCheckedInToday) {
      return Container(
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: TMLabsColor.lightGrey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          "Hôm nay đã điểm danh, mai quay lại nhé.",
          style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => interactor.checkIn(),
        style: ElevatedButton.styleFrom(
          backgroundColor: TMLabsColor.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 0,
        ),
        child: Text(
          "Điểm danh",
          style: TMLabsTextStyle.bodyBold.copyWith(color: Colors.white),
        ),
      ),
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
