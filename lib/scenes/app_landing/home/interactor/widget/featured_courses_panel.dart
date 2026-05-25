import 'package:coffee_bean/scenes/app_landing/home/interactor/home_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_strings.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/cached_image_widget.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeaturedCoursesPanel extends StatelessWidget {
  final HomeInteractor interactor;
  const FeaturedCoursesPanel({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeInteractor, HomeState>(
      buildWhen: (previous, current) => previous.featuredCoursesData != current.featuredCoursesData,
      builder: (context, state) {
        final data = state.featuredCoursesData;
        final items = data?.items ?? [];
        if (items.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.featuredCourses,
                    style: TMLabsTextStyle.h1,
                  ),
                  TapEffect(
                    onTap: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppStrings.seeMore,
                          style: TMLabsTextStyle.bodyBold,
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward, size: 18, color: TMLabsColor.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return TapEffect(
                    onTap: () => interactor.selectCourse(item),
                    child: Container(
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
                              height: 240 * 0.4,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [TMLabsColor.primary.withValues(alpha: 0), TMLabsColor.primary],
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  item.title,
                                  style: TMLabsTextStyle.title.copyWith(color: TMLabsColor.white),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
