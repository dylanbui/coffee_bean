import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import '../../models/instructor_post_model.dart';

class InstructorPostItem extends StatelessWidget {
  final InstructorPostModel data;
  final VoidCallback onTap;

  const InstructorPostItem({
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
          color: TMLabsColor.bgSecond,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Image
            DbCachedImageWidget(
              imageUrl: data.coverImage,
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
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        data.viewCount.toString(),
                        style: TMLabsTextStyle.caption.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.title,
                    style: TMLabsTextStyle.bodyBold.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: TMLabsColor.grey,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          data.authorName ?? "",
                          style: TMLabsTextStyle.caption.copyWith(color: Colors.white70, fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Video Icon
            if (data.isVideo)
              const Positioned(
                top: 12,
                right: 12,
                child: Icon(Icons.play_circle_outline, color: Colors.white, size: 24),
              ),
          ],
        ),
      ),
    );
  }
}
