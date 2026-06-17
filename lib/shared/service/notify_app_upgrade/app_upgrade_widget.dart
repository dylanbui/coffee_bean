import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppUpgradeWidget extends StatelessWidget {
  final String newVersion;
  final VoidCallback onUpdate;

  const AppUpgradeWidget({
    super.key,
    required this.newVersion,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Material(
          child: Container(
            alignment: Alignment.center,
            color: TMLabsColor.bgLight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 90.0),
                  child: Image.asset(AppAssets.images.logoTmLabs, fit: BoxFit.scaleDown),
                ),
                const Spacer(flex: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    children: [
                      Text(
                        "Có phiên bản $newVersion mới",
                        style: TMLabsTextStyle.h2.copyWith(color: TMLabsColor.primary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Vui lòng cập nhật để có trải nghiệm tốt nhất và tiếp tục sử dụng ứng dụng.",
                        style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.primary, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      AppButton(
                        text: "CẬP NHẬT NGAY",
                        onPressed: onUpdate,
                        style: TMLabsButtonStyle.primary,
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
