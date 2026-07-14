import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:flutter/material.dart';

class TopicPostItem extends StatelessWidget {
  final Post data;
  final VoidCallback? onTap;

  const TopicPostItem({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = data.postImgs?.firstOrNull ?? '';
    
    return TapEffect(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DbCachedImageWidget(imageUrl: imageUrl, fit: BoxFit.cover),
            
            // Icon Play (nếu là video - hiện tại giả định icon từ design)
            // TODO: Tam thoi khong su dung
            // Positioned(
            //   top: 15,
            //   right: 15,
            //   child: AppIcon(AppAssets.icons.icPlayVideo, size: 26),
            // ),

            // Phần thông tin phía dưới
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      TMLabsColor.primary.withValues(alpha: 0),
                      TMLabsColor.primary.withValues(alpha: 0.9),
                      TMLabsColor.primary,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Comment Count
                    Row(
                      children: [
                        AppIcon(AppAssets.icons.icComment, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          "${data.postCommentCount ?? 0}",
                          style: TMLabsTextStyle.caption.copyWith(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      (data.postTitle ?? '').toUpperCase(),
                      style: TMLabsTextStyle.bodyBold.copyWith(color: TMLabsColor.white, height: 1.3, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Author
                    Row(
                      children: [
                        AvatarWidget(
                          imageUrl: data.userAvatar ?? '',
                          size: 24,
                          backgroundColor: TMLabsColor.primary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            data.userNickname ?? 'N/A',
                            style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.white.withValues(alpha: 0.8), fontSize: 11),
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
