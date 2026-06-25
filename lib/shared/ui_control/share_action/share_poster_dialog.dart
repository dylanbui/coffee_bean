import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';

import 'package:coffee_bean/shared/ui_control/share_action/app_share_poster.dart';
import 'package:coffee_bean/shared/ui_control/share_action/poster_helper.dart';

class SharePosterDialog {
  static void show({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String shareLink,
    String? subTitle,
    String? shareText,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => Material(
        color: Colors.transparent, // Fix gạch chân cho toàn bộ Dialog
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Poster bọc trong RepaintBoundary để capture
                RepaintBoundary(
                  key: PosterHelper.boundaryKey,
                  child: AppSharePoster(
                    imageUrl: imageUrl,
                    title: title,
                    shareLink: shareLink,
                    subTitle: subTitle ?? "Quét mã để xem",
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Nút bấm lưu poster
                AppButton(
                  text: "LƯU POSTER",
                  style: TMLabsButtonStyle.primary.copyWith(
                    backgroundColor: Colors.white,
                    textColor: TMLabsColor.primary,
                    borderRadius: 100,
                    textStyle: TMLabsTextStyle.h2.copyWith(
                      color: TMLabsColor.primary,
                      decoration: TextDecoration.none, // Triệt tiêu gạch chân
                    ),
                  ),
                  width: 280,
                  height: 56,
                  onPressed: () async {
                    final bytes = await PosterHelper.captureWidget(PosterHelper.boundaryKey);
                    if (bytes != null) {
                      final success = await PosterHelper.saveToGallery(bytes);
                      if (success) {
                        DbToast.show("Đã lưu poster vào thư viện ảnh!");
                      } else {
                        DbToast.show("Không thể lưu ảnh. Vui lòng kiểm tra quyền truy cập.");
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Nút Share trực tiếp
                AppButton(
                  text: "CHIA SẺ NGAY",
                  style: TMLabsButtonStyle.primary.copyWith(
                    backgroundColor: TMLabsColor.primary,
                    textColor: Colors.white,
                    borderRadius: 100,
                    textStyle: TMLabsTextStyle.h2.copyWith(
                      color: Colors.white,
                      decoration: TextDecoration.none, // Triệt tiêu gạch chân
                    ),
                  ),
                  width: 280,
                  height: 56,
                  onPressed: () async {
                    final bytes = await PosterHelper.captureWidget(PosterHelper.boundaryKey);
                    if (bytes != null) {
                      await PosterHelper.shareImage(
                        bytes,
                        text: shareText ?? "Tham gia cùng tôi tại sự kiện: $title",
                      );
                    }
                  },
                ),
                const SizedBox(height: 32),

                // 3. Nút đóng (X)
                TapEffect(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 28),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
