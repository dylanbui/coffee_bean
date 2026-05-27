import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/avatar_widget.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class CommentItemWidget extends StatelessWidget {
  final TblComment comment;

  const CommentItemWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final List<String> images = comment.images ?? [];
    final String formattedDate = DateFormat('yyyy/MM/dd').format(comment.createdAt);

    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarWidget(
                imageUrl: comment.avatar,
                size: 40,
                backgroundColor: TMLabsColor.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName,
                      style: TMLabsTextStyle.bodyBold,
                    ),
                    Text(
                      formattedDate,
                      style: TMLabsTextStyle.caption,
                    ),
                  ],
                ),
              ),
              RatingBarIndicator(
                rating: comment.rating,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.orange,
                ),
                itemCount: 5,
                itemSize: 18.0,
                direction: Axis.horizontal,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            comment.content,
            style: TMLabsTextStyle.body.copyWith(color: Colors.black87, height: 1.4),
          ),
          if (images.isNotEmpty) ...[
            const SizedBox(height: 15),
            if (images.length == 1)
              TapEffect(
                onTap: () => context.showPhotoGallery(imageUrls: images, initialIndex: 0),
                child: DbCachedImageWidget(imageUrl: images[0], width: double.infinity, height: 200, borderRadius: 12),
              )
            else
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: TapEffect(
                        onTap: () => context.showPhotoGallery(imageUrls: images, initialIndex: index),
                        child: DbCachedImageWidget(
                          imageUrl: images[index],
                          width: 120,
                          height: 120,
                          borderRadius: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ],
      ),
    );
  }
}
