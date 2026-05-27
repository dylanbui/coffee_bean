import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';

/// Global configuration for DbCachedImageWidget
class DbCachedImageConfig {
  static String? defaultFallbackAsset;
  static BaseCacheManager? customCacheManager;

  /// Initialize global settings for images.
  /// Call this in main.dart or app_config.dart
  static void init({
    String? fallbackAsset,
    BaseCacheManager? cacheManager,
  }) {
    defaultFallbackAsset = fallbackAsset;
    customCacheManager = cacheManager;
  }
}

/// DbCachedImageWidget: Optimized image widget for Coffee Bean project.
class DbCachedImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final String? fallbackAsset;
  final bool useOldImageOnUrlChange;
  final BaseCacheManager? cacheManager;

  const DbCachedImageWidget({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.fallbackAsset,
    this.useOldImageOnUrlChange = true,
    this.cacheManager,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildErrorState();
    }

    // Optimization: Get pixel ratio without subscribing to full MediaQuery updates
    final double ratio = View.of(context).devicePixelRatio;

    // Logic xử lý MemCache để chống méo và tối ưu RAM:
    // Chúng ta chỉ cung cấp MỘT trong hai giá trị (Width hoặc Height) cho memCache.
    // Thư viện sẽ tự động resize chiều còn lại theo đúng tỷ lệ ảnh gốc (Aspect Ratio).
    int? cacheWidth;
    int? cacheHeight;

    if (width != null && height != null) {
      // Nếu có cả 2, chọn chiều lớn hơn để đảm bảo độ nét
      if (width! >= height!) {
        cacheWidth = (width! * ratio).toInt();
      } else {
        cacheHeight = (height! * ratio).toInt();
      }
    } else if (width != null) {
      cacheWidth = (width! * ratio).toInt();
    } else if (height != null) {
      cacheHeight = (height! * ratio).toInt();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        cacheManager: cacheManager ?? DbCachedImageConfig.customCacheManager,
        
        // Cấu hình đã được tối ưu chống méo hình
        memCacheWidth: cacheWidth,
        memCacheHeight: cacheHeight,
        
        useOldImageOnUrlChange: useOldImageOnUrlChange,
        placeholder: (context, url) => placeholder ?? _buildDefaultPlaceholder(),
        errorWidget: (context, url, error) => errorWidget ?? _buildErrorState(),
        fadeOutDuration: const Duration(milliseconds: 300),
        fadeInDuration: const Duration(milliseconds: 500),
        fadeInCurve: Curves.easeIn,
      ),
    );
  }

  Widget _buildDefaultPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    // Priority: local fallbackAsset > global defaultFallbackAsset > default icon
    final effectiveFallback = fallbackAsset ?? DbCachedImageConfig.defaultFallbackAsset;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: effectiveFallback != null 
        ? Image.asset(effectiveFallback, fit: fit)
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image_outlined, color: Colors.grey[400], size: 30),
              if (width != null && width! > 80) ...[
                const SizedBox(height: 4),
                Text(
                  "No Image",
                  style: TextStyle(color: Colors.grey[500], fontSize: 10),
                ),
              ]
            ],
          ),
    );
  }
}
