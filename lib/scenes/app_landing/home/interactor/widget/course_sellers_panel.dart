import 'package:coffee_bean/scenes/app_landing/home/interactor/home_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_strings.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:coffee_bean/core/utils/tap_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseSellersPanel extends StatelessWidget {
  final HomeInteractor interactor;
  const CourseSellersPanel({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeInteractor, HomeState>(
      buildWhen: (previous, current) => previous.courseSellersData != current.courseSellersData,
      builder: (context, state) {
        final data = state.courseSellersData;
        final items = data?.items ?? [];
        if (items.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                AppStrings.courseSellers,
                style: TMLabsStyle.semibold.copyWith(fontSize: 24, color: TMLabsColor.primary),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(width: 25),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return SizedBox(
                    width: 70,
                    child: Column(
                      children: [
                        TapEffect(
                          onTap: () => interactor.selectSeller(item),
                          child: AvatarWidget(
                            imageUrl: item.imageUrl,
                            size: 70,
                            backgroundColor: TMLabsColor.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.name,
                          style: TMLabsStyle.regular.copyWith(fontSize: 12, color: TMLabsColor.primary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
