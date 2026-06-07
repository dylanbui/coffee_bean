import 'package:coffee_bean/scenes/app_landing/home/interactor/home_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuickActionsPanel extends StatelessWidget {
  final HomeInteractor interactor;
  const QuickActionsPanel({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeInteractor, HomeState>(
      buildWhen: (previous, current) => previous.quickActionsData != current.quickActionsData,
      builder: (context, state) {
        final List<QuickActionItem> items = state.quickActionsData?.items ?? [];
        if (items.isEmpty) return const SizedBox.shrink();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items.map((item) {
            return TapEffect(
              onTap: () {
                if (item.key == "doi_diem") {
                  interactor.onRedeemPointsTap(context);
                } else {
                  interactor.quickActions(item);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
                      child: AppIcon(item.icon, size: 60),
                    ),
                    Text(item.label, style: const TextStyle(fontSize: 9)),
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
