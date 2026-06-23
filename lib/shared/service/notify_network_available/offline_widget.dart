import 'package:flutter/material.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/app_button.dart';

class OfflineWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const OfflineWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material( // Thêm Material để bỏ gạch chân (text underline)
        color: TMLabsColor.bgMain,
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 300),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.wifi_off,
                  size: 80,
                  color: TMLabsColor.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  "Không có kết nối mạng",
                  style: TMLabsTextStyle.h2,
                ),
                const SizedBox(height: 12),
                Text(
                  "Vui lòng kiểm tra lại kết nối Internet",
                  style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
                ),
                const SizedBox(height: 32),
                AppButton(
                  text: "Thử lại",
                  width: 200,
                  style: TMLabsButtonStyle.primary,
                  onPressed: onRetry,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
