import 'package:coffee_bean/scenes/app_landing/home/interactor/home_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_strings.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:coffee_bean/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsListPanel extends StatelessWidget {
  final HomeInteractor interactor;
  const PostsListPanel({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeInteractor, HomeState>(
      buildWhen: (previous, current) => previous.postsData != current.postsData,
      builder: (context, state) {
        final data = state.postsData;
        final items = data?.items ?? [];
        if (items.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(AppStrings.posts,
                  style: TMLabsTextStyle.h1),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length > 5 ? 5 : items.length,
              itemBuilder: (context, index) {
                return _PostCard(item: items[index], interactor: interactor);
              },
            ),
          ],
        );
      },
    );
  }
}

class _PostCard extends StatelessWidget {
  final PostItem item;
  final HomeInteractor interactor;
  const _PostCard({required this.item, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      onTap: () => interactor.selectPost(item),
      child: Container(
        height: 395,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration:
            BoxDecoration(color: TMLabsColor.bgLight, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TapEffect(
                  onTap: () => {},
                  child: AvatarWidget(
                      imageUrl: item.authorAvatar, size: 40, backgroundColor: TMLabsColor.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.authorName,
                        style: TMLabsTextStyle.bodyBold,
                      ),
                      Text(
                        "${AppStrings.postedOn} ${item.postDate}",
                        style: TMLabsTextStyle.small
                            .copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA6B5C5),
                    foregroundColor: TMLabsColor.white,
                    elevation: 0,
                    minimumSize: const Size(80, 32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text(AppStrings.follow, style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.title,
              style: TMLabsTextStyle.h2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              item.content,
              style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            if (item.images.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: item.images.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () =>
                          context.showPhotoGallery(imageUrls: item.images, initialIndex: index),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                          width: 100,
                          child:
                              DbCachedImageWidget(imageUrl: item.images[index], fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const Spacer(),
            if (item.marketData.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 8),
                child: SizedBox(
                  height: 28,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: item.marketData.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return _MarketTag(data: item.marketData[index], interactor: interactor);
                    },
                  ),
                ),
              ),
            Row(
              children: [
                TapEffect(
                    onTap: () => {},
                    child: _buildActionIcon(
                        AppAssets.icons.icShare, item.shareCount.formatCompact())),
                const SizedBox(width: 10),
                TapEffect(
                    onTap: () => {},
                    child: _buildActionIcon(
                        AppAssets.icons.icComment, item.commentCount.formatCompact())),
                const SizedBox(width: 10),
                TapEffect(
                    onTap: () => {},
                    child: _buildActionIcon(AppAssets.icons.icLike, item.likeCount.formatCompact())),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(dynamic icon, String count) {
    return Row(
      children: [
        AppIcon(icon, size: 18, color: TMLabsColor.grey),
        const SizedBox(width: 6),
        Text(count, style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey)),
      ],
    );
  }
}

class _MarketTag extends StatelessWidget {
  final MarketData data;
  final HomeInteractor interactor;
  const _MarketTag({required this.data, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      onTap: () => interactor.selectMarketTag(data),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(data.symbol, style: TMLabsTextStyle.caption.copyWith(fontSize: 11, color: Colors.black87)),
            const SizedBox(width: 4),
            Text(
              data.change,
              style: TMLabsTextStyle.small.copyWith(
                color: data.isPositive ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
