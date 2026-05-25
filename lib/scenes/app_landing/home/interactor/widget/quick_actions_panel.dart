import 'package:coffee_bean/scenes/app_landing/home/interactor/home_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_strings.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuickActionsPanel extends StatelessWidget {
  final HomeInteractor interactor;
  const QuickActionsPanel({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'icon': AppAssets.icons.icDatCho, 'label': AppStrings.booking, 'onTap': () {

        context.showFlashSuccess("Đặt chỗ thành công!", title: "Thông báo");
        interactor.quickActions(0);
      }},
      {'icon': AppAssets.icons.icDoiDiem, 'label': AppStrings.redeemPoints, 'onTap': () {

        context.showFlashError("Đổi điểm thất bại.", title: "Lỗi");
        interactor.quickActions(1);
      }},
      {'icon': AppAssets.icons.icKhoaHoc, 'label': AppStrings.allCourses, 'onTap': () {

        context.showFlashInfo("Danh sách tất cả khóa học.");
        interactor.quickActions(2);
      }},
      {'icon': AppAssets.icons.icTrungTam, 'label': AppStrings.healthCenter, 'onTap': () {

        context.showFlashWarning("Trung tâm đang bảo trì.", title: "Cảnh báo");
        interactor.quickActions(3);
      }},
    ];

    return BlocBuilder<HomeInteractor, HomeState>(
      buildWhen: (previous, current) => previous.quickActionsData != current.quickActionsData,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items.map((item) {
            return TapEffect(
              onTap: item['onTap'],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
                      child: AppIcon(item['icon'], size: 60),
                    ),
                    Text(item['label'], style: const TextStyle(fontSize: 9)),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
