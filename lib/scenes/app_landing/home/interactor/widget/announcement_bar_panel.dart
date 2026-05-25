import 'package:coffee_bean/scenes/app_landing/home/interactor/home_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';

class AnnouncementBarPanel extends StatelessWidget {
  final HomeInteractor interactor;
  const AnnouncementBarPanel({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeInteractor, HomeState>(
      buildWhen: (previous, current) => previous.announcementData != current.announcementData,
      builder: (context, state) {
        final data = state.announcementData;
        final message = data?.message ?? "";
        if (message.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          height: 44,
          decoration: BoxDecoration(color: TMLabsColor.primary, borderRadius: BorderRadius.circular(22)),
          child: Row(
            children: [
              const Icon(Icons.volume_up, color: TMLabsColor.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Marquee(
                  text: message,
                  style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.white),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  blankSpace: 20.0,
                  velocity: 30.0,
                  pauseAfterRound: const Duration(seconds: 1),
                  accelerationDuration: const Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: const Duration(milliseconds: 500),
                  decelerationCurve: Curves.easeOut,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: TMLabsColor.white, size: 14),
            ],
          ),
        );
      },
    );
  }
}
