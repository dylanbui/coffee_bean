/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 03:35
 * Description: Wrapper cho DbFlashImageHelper để giữ tính tương thích trong project.
 */

import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:db_core/utils/flash_utils/flash_image_helper.dart';
import 'package:flutter/material.dart';

class FlashImageHelper {
  /// Hiển thị bộ sưu tập ảnh full màn hình
  static void showGallery({
    required BuildContext context,
    required List<String> imageUrls,
    int initialIndex = 0,
    String? heroTagPrefix,
  }) {
    DbFlashImageHelper.showGallery(
      context: context,
      imageUrls: imageUrls,
      initialIndex: initialIndex,
      heroTagPrefix: heroTagPrefix,
      indicatorColor: TMLabsColor.primary, // Coffee Bean brand color
    );
  }
}

/*
  // --- CÁCH SỬ DỤNG TRONG PROJECT COFFEE BEAN ---

  // 1. Xem ảnh đơn
  void _viewProductImage(String url) {
    FlashImageHelper.showGallery(
      context: context,
      imageUrls: [url],
    );
  }

  // 2. Xem danh sách ảnh Feedback (Có kèm Hero Tag)
  void _viewFeedbackGallery(List<String> images, int index) {
    FlashImageHelper.showGallery(
      context: context,
      imageUrls: images,
      initialIndex: index,
      heroTagPrefix: "feedback_hero",
    );
  }
*/
