
/*
 * Created with Android Studio
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 09:00
 * Description: Wrapper class cho Toast để tránh phụ thuộc trực tiếp vào Vendor Library.
 */

import 'package:db_core/architecture_ribs/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flash/flash.dart';
import 'package:db_core/utils/common_style.dart';

enum DbToastGravity { top, bottom, center }

class DbToast {

    static void show(
        String message, {
            BuildContext? context,
            DbToastGravity gravity = DbToastGravity.bottom,
            Duration duration = const Duration(seconds: 1),
            TextStyle? style,
        }) {
        // 1. Lấy context thông qua Helper trung gian đã có
        final effectiveContext = context ?? DbNavigator.globalNavigatorState.currentContext;
        if (effectiveContext == null) return;

        final textStyle = style ?? DbCommonStyle.toastTextStyle;

        // 2. Chuyển đổi tham số của DbToast sang tham số của Flash (Logic đóng gói)
        final position = gravity == DbToastGravity.top ? FlashPosition.top : FlashPosition.bottom;

        // 3. Thực thi thông qua Flash (Nhưng được bọc kín bên trong DbToast)
        showFlash(
            context: effectiveContext,
            duration: duration,
            builder: (context, controller) {
                return Flash(
                    controller: controller,
                    position: position,
                    child: FadeTransition(
                        opacity: controller.controller,
                        child: Align(
                            alignment: gravity == DbToastGravity.top ? Alignment.topCenter : Alignment.bottomCenter,
                            child: Container(
                                margin: gravity == DbToastGravity.top 
                                    ? const EdgeInsets.only(top: 50, left: 40, right: 40)
                                    : const EdgeInsets.only(bottom: 80, left: 40, right: 40),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                    message,
                                    style: textStyle.copyWith(color: Colors.white),
                                    textAlign: TextAlign.center,
                                ),
                            ),
                        ),
                    ),
                );
            },
        );
    }
}
