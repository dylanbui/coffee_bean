import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Widget để hiển thị hình ảnh từ URL với cache
///
/// Features:
/// - Tự động cache hình ảnh
/// - Loading indicator mượt
/// - Error handling
/// - Rounded corners tùy chỉnh
class CachedImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedImageWidget({
    super.key,
    this.imageUrl,
    this.width = 100,
    this.height = 100,
    this.borderRadius = 8,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: (imageUrl != null && imageUrl!.isNotEmpty)
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              width: width,
              height: height,
              fit: fit,
              placeholder: (context, url) =>
                  placeholder ??
                  Container(
                    width: width,
                    height: height,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey)),
                  ),
              errorWidget: (context, url, error) =>
                  errorWidget ?? Container(width: width, height: height, color: Colors.grey[300], child: const Icon(Icons.error)),
              fadeOutDuration: const Duration(milliseconds: 300),
              fadeInDuration: const Duration(milliseconds: 300),
            )
          : Container(width: width, height: height, color: Colors.grey[300], child: const Icon(Icons.image)),
    );
  }
}
