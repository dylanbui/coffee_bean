/*
 * Created with Android Studio
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 03:30
 * Description: Base Utility hỗ trợ xem ảnh đơn hoặc danh sách ảnh (Gallery)
 * tích hợp tính năng zoom, vuốt và hiển thị chỉ số trang.
 * Sử dụng extended_image. Thiết kế để dùng chung trong db_core.
 */

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

class DbFlashImageHelper {
  /// Hiển thị bộ sưu tập ảnh full màn hình
  /// [imageUrls]: Danh sách đường dẫn ảnh (Network URL)
  /// [initialIndex]: Vị trí ảnh bắt đầu hiển thị
  /// [heroTagPrefix]: Prefix cho hiệu ứng Hero transition (nếu dùng)
  static void showGallery({
    required BuildContext context,
    required List<String> imageUrls,
    int initialIndex = 0,
    String? heroTagPrefix,
    Color? indicatorColor,
  }) {
    if (imageUrls.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _DbPhotoGalleryPage(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
          heroTagPrefix: heroTagPrefix,
          indicatorColor: indicatorColor,
        ),
      ),
    );
  }
}

class _DbPhotoGalleryPage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String? heroTagPrefix;
  final Color? indicatorColor;

  const _DbPhotoGalleryPage({
    required this.imageUrls,
    required this.initialIndex,
    this.heroTagPrefix,
    this.indicatorColor,
  });

  @override
  State<_DbPhotoGalleryPage> createState() => _DbPhotoGalleryPageState();
}

class _DbPhotoGalleryPageState extends State<_DbPhotoGalleryPage> {
  late ValueNotifier<int> _currentIndexNotifier;
  late ExtendedPageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndexNotifier = ValueNotifier<int>(widget.initialIndex);
    _pageController = ExtendedPageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _currentIndexNotifier.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ExtendedImageGesturePageView.builder(
            itemCount: widget.imageUrls.length,
            controller: _pageController,
            onPageChanged: (index) {
              _currentIndexNotifier.value = index;
            },
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ExtendedImage.network(
                widget.imageUrls[index],
                fit: BoxFit.contain,
                mode: ExtendedImageMode.gesture,
                heroBuilderForSlidingPage: widget.heroTagPrefix != null
                    ? (Widget image) => Hero(tag: '${widget.heroTagPrefix}_$index', child: image)
                    : null,
                initGestureConfigHandler: (state) {
                  return GestureConfig(
                    minScale: 0.9,
                    maxScale: 3.0,
                    speed: 1.0,
                    initialScale: 1.0,
                    inPageView: true,
                  );
                },
                loadStateChanged: (state) {
                  if (state.extendedImageLoadState == LoadState.loading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: widget.indicatorColor ?? Colors.white,
                        strokeWidth: 2,
                      ),
                    );
                  }
                  return null;
                },
              );
            },
          ),

          // Nút Đóng
          Positioned(
            top: mediaQuery.padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Chỉ số trang
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: mediaQuery.padding.bottom + 30,
              child: ValueListenableBuilder<int>(
                valueListenable: _currentIndexNotifier,
                builder: (context, index, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "${index + 1} / ${widget.imageUrls.length}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
