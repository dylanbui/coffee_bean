/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 02:05
 * Description: Triển khai DbFlashToastStyleProvider cho dự án Coffee Bean
 */

import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/flash_utils/flash_toast_helper.dart';
import 'package:flutter/material.dart';

class TMLabsToastStyleProvider implements DbFlashToastStyleProvider {
  @override
  DbFlashToastStyle getStyle(DbFlashToastType type) {
    switch (type) {
      case DbFlashToastType.success:
        return DbFlashToastStyle(
          backgroundColor: TMLabsColor.success,
          iconData: Icons.check_circle_outline,
          titleStyle: TMLabsTextStyle.title.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          messageStyle: TMLabsTextStyle.body.copyWith(color: Colors.white),
        );
      case DbFlashToastType.error:
        return DbFlashToastStyle(
          backgroundColor: TMLabsColor.error,
          iconData: Icons.error_outline,
          titleStyle: TMLabsTextStyle.title.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          messageStyle: TMLabsTextStyle.body.copyWith(color: Colors.white),
        );
      case DbFlashToastType.warning:
        return DbFlashToastStyle(
          backgroundColor: TMLabsColor.warning,
          iconData: Icons.warning_amber_rounded,
          titleStyle: TMLabsTextStyle.title.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          messageStyle: TMLabsTextStyle.body.copyWith(color: Colors.white),
        );
      case DbFlashToastType.info:
        return DbFlashToastStyle(
          backgroundColor: TMLabsColor.primary,
          iconData: Icons.info_outline,
          titleStyle: TMLabsTextStyle.title.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          messageStyle: TMLabsTextStyle.body.copyWith(color: Colors.white),
        );
    }
  }

  /// Khởi tạo Toast Helper với Style của dự án Coffee Bean
  static void init() {
    DbFlashToastHelper.init(TMLabsToastStyleProvider());
  }
}

/// Alias để giữ tính tương thích với code cũ
// typedef FlashToastHelper = DbFlashToastHelper;
// typedef FlashToastType = DbFlashToastType;
// typedef FlashToastStyle = DbFlashToastStyle;
