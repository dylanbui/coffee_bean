import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/utils/flash_utils/flash_toast_helper.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';

class PointStoreCard extends StatelessWidget {
  final TblStorePoint item;
  final ValueChanged<TblStorePoint>? onTap;

  const PointStoreCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      effectType: TapEffectType.ripple,
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        DbFlashToastHelper.info(context, "ID: ${item.id} - Name: ${item.name}");
        onTap?.call(item);
      },
      child: Container(
        // width: 176,
        // height: 250,
        decoration: BoxDecoration(
          color: TMLabsColor.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section - height 160px
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: DbCachedImageWidget(
                imageUrl: item.mainImage ?? "",
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            // Content section
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TMLabsTextStyle.body.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "${item.points.toInt()}",
                        style: TMLabsTextStyle.bodyBold.copyWith(
                          fontSize: 16,
                          color: TMLabsColor.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Điểm",
                        style: TMLabsTextStyle.caption.copyWith(
                          color: TMLabsColor.grey,
                        ),
                      ),
                    ],
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
