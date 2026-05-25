import 'package:coffee_bean/scenes/app_landing/home/interactor/home_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromoBannerPanel extends StatelessWidget {
  final HomeInteractor interactor;
  const PromoBannerPanel({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeInteractor, HomeState>(
      buildWhen: (previous, current) => previous.promoData != current.promoData,
      builder: (context, state) {
        final data = state.promoData;
        if (data == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(data.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: TMLabsColor.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text(AppStrings.seeMore, style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
