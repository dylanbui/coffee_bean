import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AppSharePoster extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String shareLink;
  final String? subTitle;

  const AppSharePoster({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.shareLink,
    this.subTitle = "Quét mã để xem",
  });

  @override
  Widget build(BuildContext context) {
    // Sử dụng Material trắng, không bo tròn để Poster khi lưu file là một hình chữ nhật sạch sẽ
    return Material(
      color: Colors.white,
      child: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Ảnh đại diện (Hình vuông/Chữ nhật phẳng)
            DbCachedImageWidget(
              imageUrl: imageUrl,
              width: double.infinity,
              height: 316, 
              fit: BoxFit.cover,
              borderRadius: 0,
            ),

            // 2. Thông tin QR & Title
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // QR Code
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: TMLabsColor.bgLight, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: QrImageView(
                      data: shareLink,
                      version: QrVersions.auto,
                      size: 70.0,
                      gapless: false,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Text info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TMLabsTextStyle.h2.copyWith(
                            fontSize: 18, 
                            color: TMLabsColor.primary,
                            fontWeight: FontWeight.w900,
                            decoration: TextDecoration.none,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subTitle!,
                          style: TMLabsTextStyle.caption.copyWith(
                            color: TMLabsColor.grey,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
