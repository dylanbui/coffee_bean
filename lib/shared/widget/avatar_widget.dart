import 'dart:io';
import 'package:db_core/utils/widget/cached_image_widget.dart';
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
    Widget image;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      if (imageUrl!.startsWith('/') || imageUrl!.startsWith('file://')) {
        image = Image.file(
          File(imageUrl!.replaceFirst('file://', '')),
          fit: BoxFit.cover,
        );
      } else {
        image = DbCachedImageWidget(
          imageUrl: imageUrl!,
          fit: BoxFit.cover,
        );
      }
    } else if (placeholderAsset != null) {
      image = Image.asset(placeholderAsset!, fit: BoxFit.cover);
    } else {
      image = const SizedBox.shrink();
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: ClipOval(child: image),
    );
  }
}
