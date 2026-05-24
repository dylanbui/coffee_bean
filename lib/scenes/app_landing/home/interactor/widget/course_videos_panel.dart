import 'package:coffee_bean/scenes/app_landing/home/interactor/home_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_strings.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:coffee_bean/shared/widget/cached_image_widget.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseVideosPanel extends StatelessWidget {
  final HomeInteractor interactor;
  const CourseVideosPanel({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeInteractor, HomeState>(
      buildWhen: (previous, current) => previous.courseVideosData != current.courseVideosData,
      builder: (context, state) {
        final data = state.courseVideosData;
        final items = data?.items ?? [];
        if (items.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                AppStrings.courseVideos,
                style: TMLabsStyle.semibold.copyWith(fontSize: 24, color: TMLabsColor.primary),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _CourseVideoCard(item: items[index], interactor: interactor);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CourseVideoCard extends StatelessWidget {
  final CourseVideoItem item;
  final HomeInteractor interactor;
  const _CourseVideoCard({required this.item, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedImageWidget(imageUrl: item.imageUrl, fit: BoxFit.cover),
            Positioned(
              top: 15,
              right: 15,
              child: TapEffect(
                onTap: () => interactor.playVideo(item),
                child: AppIcon(AppAssets.icons.icPlayVideo, size: 26),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 250 * 0.6,
              child: Container(
                padding: const EdgeInsets.all(15),
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
                      item.title.toUpperCase(),
                      style: TMLabsStyle.semibold.copyWith(color: Colors.white, fontSize: 13, height: 1.3),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        TapEffect(
                          onTap: () => {},
                          child: AvatarWidget(
                            imageUrl: item.authorAvatar,
                            size: 40,
                            backgroundColor: TMLabsColor.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item.authorName,
                            style: TMLabsStyle.regular.copyWith(color: Colors.white.withOpacity(0.8), fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
