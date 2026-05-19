import 'package:coffee_bean/scenes/app_landing/home/interactor/home_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_strings.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/cached_image_widget.dart';
import 'package:coffee_bean/core/utils/tap_effect.dart';
import 'package:coffee_bean/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinancialCoursesPanel extends StatelessWidget {
  final HomeInteractor interactor;
  const FinancialCoursesPanel({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeInteractor, HomeState>(
      buildWhen: (previous, current) => previous.financialCoursesData != current.financialCoursesData,
      builder: (context, state) {
        final data = state.financialCoursesData;
        final items = data?.items ?? [];
        if (items.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                AppStrings.financialCourses,
                style: TMLabsStyle.semibold.copyWith(fontSize: 24, color: TMLabsColor.primary),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _FinancialCourseCard(item: items[index], interactor: interactor);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FinancialCourseCard extends StatelessWidget {
  final FinancialCourseItem item;
  final HomeInteractor interactor;
  const _FinancialCourseCard({required this.item, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedImageWidget(imageUrl: item.imageUrl, fit: BoxFit.cover),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 230 * 0.55,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      TMLabsColor.primary.withOpacity(0),
                      TMLabsColor.primary.withOpacity(0.9),
                      TMLabsColor.primary,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      item.title,
                      style: TMLabsStyle.semibold.copyWith(color: Colors.white, fontSize: 13, height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.price.toVnd(),
                          style: TMLabsStyle.semibold.copyWith(color: Colors.white, fontSize: 14),
                        ),
                        TapEffect(
                          onTap: () => interactor.addToCart(item),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFA6B5C5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
