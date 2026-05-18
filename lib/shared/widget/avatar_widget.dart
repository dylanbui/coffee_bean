import 'package:coffee_bean/shared/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String? placeholderAsset;
  final Color? backgroundColor;

  const AvatarWidget({
    super.key,
    this.imageUrl,
    this.size = 40,
    this.placeholderAsset,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: (imageUrl != null && imageUrl!.isNotEmpty)
            ? CachedImageWidget(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
              )
            : (placeholderAsset != null
                ? Image.asset(placeholderAsset!, fit: BoxFit.cover)
                : const SizedBox.shrink()),
      ),
    );
  }
}
