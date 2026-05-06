
/*
 * Created with Android Studio
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 09:00
 * Description: Wrapper class cho Toast để tránh phụ thuộc trực tiếp vào Vendor Library.
 */

import 'package:coffee_bean/commons/architecture_ribs/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flash/flash.dart';
import 'package:coffee_bean/commons/utils/common_style.dart';

enum DbToastGravity { top, bottom, center }

class DbToast {

    static void show(
        String message, {
            BuildContext? context,
            DbToastGravity gravity = DbToastGravity.bottom,
            Duration duration = const Duration(seconds: 2),
            TextStyle? style,
        }) {
        // 1. Lấy context thông qua Helper trung gian đã có
        final effectiveContext = context ?? DbNavigator.navigatorState.currentContext;
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
                    child: DefaultTextStyle(
                        style: textStyle,
                        child: FlashBar(
                            controller: controller,
                            behavior: FlashBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
                            backgroundColor: Colors.black87,
                            content: Text(
                                message,
                                textAlign: TextAlign.center,
                            ),
                        ),
                    ),
                );
            },
        );
    }
}