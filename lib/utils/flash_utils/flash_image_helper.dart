/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 00:28
 * To change this template use File | Settings | File Templates.
 */


/*
 * Created with Android Studio
 * Package: commons/helpers
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 00:15
 * Description: Utility hỗ trợ xem ảnh đơn hoặc danh sách ảnh (Gallery)
 * tích hợp tính năng zoom, vuốt và hiển thị chỉ số trang.
 */

import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
                builder: (context) => _PhotoGalleryPage(
                    imageUrls: imageUrls,
                    initialIndex: initialIndex,
                    heroTagPrefix: heroTagPrefix,
                ),
            ),
        );
    }
}

class _PhotoGalleryPage extends StatefulWidget {
    final List<String> imageUrls;
    final int initialIndex;
    final String? heroTagPrefix;

    const _PhotoGalleryPage({
        required this.imageUrls,
        required this.initialIndex,
        this.heroTagPrefix,
    });

    @override
    State<_PhotoGalleryPage> createState() => _PhotoGalleryPageState();
}

class _PhotoGalleryPageState extends State<_PhotoGalleryPage> {
    late int currentIndex = widget.initialIndex;
    late PageController _pageController;

    @override
    void initState() {
        super.initState();
        _pageController = PageController(initialPage: widget.initialIndex);
    }

    @override
    void dispose() {
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
                    // Widget chính xử lý hiển thị và Zoom ảnh
                    PhotoViewGallery.builder(
                        itemCount: widget.imageUrls.length,
                        pageController: _pageController,
                        onPageChanged: (index) {
                            setState(() => currentIndex = index);
                        },
                        scrollPhysics: const BouncingScrollPhysics(), // Hiệu ứng nảy chuẩn iOS
                        builder: (context, index) {
                            return PhotoViewGalleryPageOptions(
                                imageProvider: NetworkImage(widget.imageUrls[index]),
                                // Tự động căn chỉnh ảnh nằm gọn trong màn hình
                                initialScale: PhotoViewComputedScale.contained,
                                // Giới hạn mức độ phóng to/thu nhỏ
                                minScale: PhotoViewComputedScale.contained * 0.8,
                                maxScale: PhotoViewComputedScale.covered * 2,
                                heroAttributes: widget.heroTagPrefix != null
                                    ? PhotoViewHeroAttributes(tag: '${widget.heroTagPrefix}_$index')
                                    : null,
                            );
                        },
                        loadingBuilder: (context, event) => const Center(
                            child: CircularProgressIndicator(
                                color: Colors.brown, // Màu thương hiệu Coffee Bean
                                strokeWidth: 2,
                            ),
                        ),
                    ),

                    // Nút Đóng (Top Left) - Tối ưu SafeArea cho iOS
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
                            child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                    "${currentIndex + 1} / ${widget.imageUrls.length}",
                                    style: TMLabsTextStyle.caption.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                    ),
                                ),
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
  // 1. Sử dụng qua Extension (Khuyên dùng)
  // File: context_ext.dart
  // context.showPhotoGallery(urls: ["https://link-to-coffee-image.jpg"]);

  // 2. Xem ảnh đơn (Ví dụ: Ảnh sản phẩm Arabica)
  void _viewProductImage(String url) {
    FlashImageHelper.showGallery(
      context: context,
      imageUrls: [url],
    );
  }

  // 3. Xem danh sách ảnh Feedback (Có kèm Hero Tag)
  // Hero Tag giúp hiệu ứng mở ảnh mượt mà từ vị trí nhấn
  void _viewFeedbackGallery(List<String> images, int index) {
    FlashImageHelper.showGallery(
      context: context,
      imageUrls: images,
      initialIndex: index,
      heroTagPrefix: "feedback_hero",
    );
  }

  // 4. Widget thực tế hiển thị Hero
  Widget _buildImageItem(String url, int index) {
    return Hero(
      tag: "feedback_hero_$index",
      child: GestureDetector(
        onTap: () => _viewFeedbackGallery(allImages, index),
        child: Image.network(url),
      ),
    );
  }
*/
