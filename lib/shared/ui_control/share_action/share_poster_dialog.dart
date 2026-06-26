import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
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
                // Container chính bọc cả Poster và Menu Action
                Container(
                  width: 340,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 1. Poster bọc trong RepaintBoundary để capture (giữ nguyên tỷ lệ)
                      RepaintBoundary(
                        key: PosterHelper.boundaryKey,
                        child: AppSharePoster(
                          imageUrl: imageUrl,
                          title: title,
                          shareLink: shareLink,
                          subTitle: subTitle ?? "Quét mã để xem",
                        ),
                      ),
                      
                      // 2. Action Area (Nền xanh nhạt)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 24, bottom: 32),
                        color: const Color(0xFFF5F7FF), // Màu nền nhạt theo thiết kế
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton(
                              context: context,
                              icon: Icons.share_outlined,
                              label: "Chia sẻ",
                              onTap: () async {
                                final bytes = await PosterHelper.captureWidget(PosterHelper.boundaryKey);
                                if (bytes != null) {
                                  await PosterHelper.shareImage(
                                    bytes,
                                    text: shareText ?? "Tham gia cùng tôi tại sự kiện: $title",
                                  );
                                }
                              },
                            ),
                            _buildActionButton(
                              context: context,
                              icon: Icons.save_alt_outlined,
                              label: "Lưu",
                              onTap: () async {
                                final bytes = await PosterHelper.captureWidget(PosterHelper.boundaryKey);
                                if (bytes != null) {
                                  final success = await PosterHelper.saveToGallery(bytes);
                                  // Kiểm tra context còn hợp lệ sau các thao tác await (async gap)
                                  if (!context.mounted) return;
                                  if (success) {
                                    context.showFlashSuccess("Đã lưu poster vào thư viện ảnh!");
                                  } else {
                                    context.showFlashError("Không thể lưu ảnh. Vui lòng kiểm tra quyền truy cập.");
                                  }
                                }
                              },
                            ),
                            _buildActionButton(
                              context: context,
                              icon: Icons.close_outlined,
                              label: "Đóng",
                              onTap: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return TapEffect(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: TMLabsColor.primary.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: TMLabsColor.primary, size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TMLabsTextStyle.bodyBold.copyWith(
              color: TMLabsColor.primary,
              fontSize: 13,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
