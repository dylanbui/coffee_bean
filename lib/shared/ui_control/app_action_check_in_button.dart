import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:flutter/material.dart';

class AppActionCheckInButton extends StatefulWidget {
  final bool isCheckedIn;
  final Future<void> Function()? onTap;

  const AppActionCheckInButton({
    super.key,
    required this.isCheckedIn,
    this.onTap,
  });

  @override
  State<AppActionCheckInButton> createState() => _AppActionCheckInButtonState();
}

class _AppActionCheckInButtonState extends State<AppActionCheckInButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Chỉ cho phép bấm khi chưa điểm danh, không đang loading và có callback
    final bool canTap = !widget.isCheckedIn && !_isLoading && widget.onTap != null;

    return TapEffect(
      onTap: canTap ? _handleTap : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Icon nền tĩnh
              AppIcon(
                AppAssets.icons.icCheckboxBg,
                size: 36,
              ),
              if (_isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(TMLabsColor.primary),
                  ),
                )
              else
                AppIcon(
                  AppAssets.icons.icCheckboxCircle,
                  size: 16,
                  color: widget.isCheckedIn ? TMLabsColor.success : const Color(0xFFCECCCD),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _isLoading ? 'Đang xử lý' : (widget.isCheckedIn ? 'Đã điểm danh' : 'Điểm danh'),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleTap() async {
    setState(() => _isLoading = true);
    try {
      await widget.onTap?.call();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
