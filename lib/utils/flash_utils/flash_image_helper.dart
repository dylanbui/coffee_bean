/*
 * Created with Android Studio
 * Package: commons/helpers
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 00:15
 * Description: Utility hỗ trợ xem ảnh đơn hoặc danh sách ảnh (Gallery)
 * tích hợp tính năng zoom, vuốt và hiển thị chỉ số trang.
 * Đã chuyển sang sử dụng extended_image để giải quyết lỗi xung đột cử chỉ (vuốt 2 lần).
 */

import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

class FlashImageHelper {
  /// Hiển thị bộ sưu tập ảnh full màn hình
  /// [imageUrls]: Danh sách đường dẫn ảnh (Network URL)
  /// [initialIndex]: Vị trí ảnh bắt đầu hiển thị
  /// [heroTagPrefix]: Prefix cho hiệu ứng Hero transition (nếu dùng)
  static void showGallery({
    required BuildContext context,
    required List<String> imageUrls,
    int initialIndex = 0,
    String? heroTagPrefix,
  }) {
    if (imageUrls.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            _PhotoGalleryPage(imageUrls: imageUrls, initialIndex: initialIndex, heroTagPrefix: heroTagPrefix),
      ),
    );
  }
}

class _PhotoGalleryPage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String? heroTagPrefix;

  const _PhotoGalleryPage({required this.imageUrls, required this.initialIndex, this.heroTagPrefix});

  @override
  State<_PhotoGalleryPage> createState() => _PhotoGalleryPageState();
}

class _PhotoGalleryPageState extends State<_PhotoGalleryPage> {
  late ValueNotifier<int> _currentIndexNotifier;
  late ExtendedPageController _pageController; // Sử dụng ExtendedPageController

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
          // Sử dụng ExtendedImageGesturePageView để xử lý vuốt trang mượt mà
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
                mode: ExtendedImageMode.gesture, // Bật tính năng zoom/pan
                // Cấu hình Hero animation thông qua heroBuilderForSlidingPage
                heroBuilderForSlidingPage: widget.heroTagPrefix != null
                    ? (Widget image) => Hero(tag: '${widget.heroTagPrefix}_$index', child: image)
                    : null,
                // Cấu hình cử chỉ quan trọng để sửa lỗi vuốt 2 lần
                initGestureConfigHandler: (state) {
                  return GestureConfig(
                    minScale: 0.9,
                    maxScale: 3.0,
                    speed: 1.0,
                    initialScale: 1.0,
                    // Dòng này giúp ExtendedImage nhường quyền cho PageView ngay lập tức
                    inPageView: true,
                  );
                },
                // Loading indicator
                loadStateChanged: (state) {
                  if (state.extendedImageLoadState == LoadState.loading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.brown, strokeWidth: 2));
                  }
                  return null;
                },
              );
            },
          ),

          // Nút Đóng (Top Left)
          Positioned(
            top: mediaQuery.padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Chỉ số trang (Bottom Center)
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
                      style: TMLabsTextStyle.caption.copyWith(
                        color: Colors.white,
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

/// **************************************************************************
/// EXAMPLES - CÁCH SỬ DỤNG TRONG PROJECT COFFEE BEAN
/// **************************************************************************

/*
  // 1. Xem ảnh đơn (Ví dụ: Ảnh sản phẩm Arabica)
  void _viewProductImage(String url) {
    FlashImageHelper.showGallery(
      context: context,
      imageUrls: [url],
    );
  }

  // 2. Xem danh sách ảnh Feedback (Có kèm Hero Tag)
  // Hero Tag giúp hiệu ứng mở ảnh mượt mà từ vị trí nhấn
  void _viewFeedbackGallery(List<String> images, int index) {
    FlashImageHelper.showGallery(
      context: context,
      imageUrls: images,
      initialIndex: index,
      heroTagPrefix: "feedback_hero",
    );
  }

  // 3. Widget thực tế hiển thị Hero
  Widget _buildImageItem(String url, int index) {
    return GestureDetector(
      onTap: () => _viewFeedbackGallery(allImages, index),
      child: Hero(
        tag: "feedback_hero_$index",
        child: CachedImageWidget(imageUrl: url),
      ),
    );
  }
*/
