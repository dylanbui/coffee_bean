import 'package:coffee_bean/data/model/response/hub/post.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';

class ExpertPostItem extends StatelessWidget {
  final Post data;
  final VoidCallback onTap;

  const ExpertPostItem({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: TMLabsColor.grey,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Image
            DbCachedImageWidget(
              imageUrl: (data.postImgs?.isNotEmpty ?? false) ? data.postImgs!.first : '',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            
            // Overlay Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      AppIcon(AppAssets.icons.icComment, size: 12, color: TMLabsColor.white),
                      const SizedBox(width: 4),
                      Text(
                        (data.postCommentCount ?? 0).toString(),
                        style: TMLabsTextStyle.caption.copyWith(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.postTitle ?? '',
                    style: TMLabsTextStyle.bodyBold.copyWith(
                      color: Colors.white,
                      fontSize: 11,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
