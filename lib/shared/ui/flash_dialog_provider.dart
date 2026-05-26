/*
 * Created with Android Studio
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 03:10
 * Description: Triển khai DbFlashDialogStyleProvider cho dự án Coffee Bean
 */

import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/flash_utils/flash_dialog_helper.dart';
import 'package:flutter/material.dart';

class TMLabsDialogStyleProvider implements DbFlashDialogStyleProvider {
  @override
  DbFlashDialogStyle getStyle() {
    return DbFlashDialogStyle(
      titleStyle: TMLabsTextStyle.h2,
      contentStyle: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
      primaryActionColor: TMLabsColor.primary,
      borderRadius: 20.0,
    );
  }

  @override
  Widget? getIcon(DbFlashDialogType type) {
    switch (type) {
      case DbFlashDialogType.info:
        return const Icon(Icons.info, color: TMLabsColor.primary, size: 40);
      case DbFlashDialogType.success:
        return const Icon(Icons.check_circle, color: TMLabsColor.success, size: 40);
      case DbFlashDialogType.error:
        return const Icon(Icons.error, color: TMLabsColor.error, size: 40);
      case DbFlashDialogType.warning:
        return const Icon(Icons.warning, color: TMLabsColor.warning, size: 40);
    }
  }

  @override
  String getDefaultTitle(DbFlashDialogType type) {
    switch (type) {
      case DbFlashDialogType.info: return "Thông báo";
      case DbFlashDialogType.success: return "Thành công";
      case DbFlashDialogType.error: return "Lỗi";
      case DbFlashDialogType.warning: return "Cảnh báo";
    }
  }

  /// Khởi tạo Dialog Helper với Style của dự án Coffee Bean
  static void init() {
    DbFlashDialogHelper.init(TMLabsDialogStyleProvider());
  }
}
