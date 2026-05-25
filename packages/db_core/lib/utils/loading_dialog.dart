/*
 * Created with Android Studio
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 4/5/26 - 17:15
 * Description: Global Loading management, supports dynamic content updates via ValueNotifier.
 */

import 'package:db_core/architecture_ribs/navigator.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:db_core/utils/common_style.dart';

class DbLoadingStyle {
  final TextStyle textStyle;
  final Color progressColor;
  final Color backgroundColor;
  final double borderRadius;

  const DbLoadingStyle({
    required this.textStyle,
    required this.progressColor,
    this.backgroundColor = Colors.white,
    this.borderRadius = 16.0,
  });
}

/// Standard Dialog Loading (Blocks UI with a centered modal)
class DbLoading {
  static FlashController? _currentController;
  static bool _isShowing = false;

  // ValueNotifier used to update the message without rebuilding the entire Modal
  static final ValueNotifier<String> _messageNotifier = ValueNotifier<String>("");

  /// Show global loading dialog
  static void show(BuildContext context, {String? message, DbLoadingStyle? style}) {
    final msg = message ?? "Processing...";
    final effectiveStyle = style ?? DbCommonStyle.defaultLoadingStyle;

    // If already showing, just update the message
    if (_isShowing || _currentController != null) {
      _messageNotifier.value = msg;
      return;
    }

    _isShowing = true;
    _messageNotifier.value = msg;

    showFlash<void>(
      context: context,
      persistent: true,
      builder: (context, controller) {
        _currentController = controller;

        return Flash(
          controller: controller,
          child: PopScope(
            canPop: false,
            child: Material(
              type: MaterialType.transparency,
              child: DefaultTextStyle(
                style: effectiveStyle.textStyle,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: effectiveStyle.backgroundColor,
                      borderRadius: BorderRadius.circular(effectiveStyle.borderRadius),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: effectiveStyle.progressColor),
                        const SizedBox(height: 16),
                        ValueListenableBuilder<String>(
                          valueListenable: _messageNotifier,
                          builder: (context, value, child) {
                            return Text(value, textAlign: TextAlign.center);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      // Khi flash bị đóng (bằng bất cứ lý do gì), reset lại trạng thái
      _currentController = null;
      _isShowing = false;
    });
  }

  /// Đóng Loading
  static void dismiss() {
    _currentController?.dismiss();
    _currentController = null;
    _isShowing = false;
    _messageNotifier.value = "";
  }

  // static FlashController? _lineController;
  //
  // static void showPage({BuildContext? context, double appBarHeight = kToolbarHeight, Color backgroundColor = Colors.white, String? message, TextStyle? style}) {
  //   if (_lineController != null) return;
  //
  //   final effectiveContext = context ?? DbNavigator.globalNavigatorState.currentContext;
  //   if (effectiveContext == null) return;
  //
  //   final double topPadding = MediaQuery.of(effectiveContext).padding.top;
  //   final textStyle = style ?? DbCommonStyle.defaultLoadingStyle.textStyle;
  //
  //   showFlash<void>(
  //     context: effectiveContext,
  //     builder: (context, controller) {
  //       _lineController = controller;
  //
  //       return Flash(
  //         controller: controller,
  //         position: FlashPosition.top,
  //         child: PopScope(
  //           canPop: false,
  //           child: Stack(
  //             children: [
  //               // 1. LỚP NỀN TRẮNG (Hoặc tùy chỉnh)
  //               Positioned.fill(
  //                 top: topPadding + appBarHeight,
  //                 child: Container(
  //                   color: backgroundColor,
  //                   child: message != null ? Center(child: Text(message, style: textStyle)) : null,
  //                 ),
  //               ),
  //
  //               // 2. INDICATOR (iOS: Spinner nhỏ, Android: Thanh Line)
  //               _buildPageIndicator(effectiveContext, topPadding, appBarHeight),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  //
  // /// Helper build indicator theo nền tảng cho Page Loading
  // static Widget _buildPageIndicator(BuildContext context, double topPadding, double appBarHeight) {
  //   final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  //
  //   if (isIOS) {
  //     // iOS: Hiện loading nhỏ (native) bên dưới appbar cách appbar 10px
  //     return Positioned(
  //       top: topPadding + appBarHeight + 10,
  //       left: 0,
  //       right: 0,
  //       child: const Center(child: CupertinoActivityIndicator(color: Colors.brown)),
  //     );
  //   } else {
  //     // Android/Web: Thanh line màu dưới appbar (giống load trang web)
  //     return Positioned(
  //       top: topPadding + appBarHeight,
  //       left: 0,
  //       right: 0,
  //       child: TweenAnimationBuilder<double>(
  //         tween: Tween<double>(begin: 0.0, end: 0.95),
  //         duration: const Duration(seconds: 15),
  //         curve: Curves.easeOutExpo,
  //         builder: (context, value, child) {
  //           return LinearProgressIndicator(value: value, minHeight: 2.5, valueColor: const AlwaysStoppedAnimation<Color>(Colors.brown), backgroundColor: Colors.transparent);
  //         },
  //       ),
  //     );
  //   }
  // }
  //
  // static void dismissPage() {
  //   _lineController?.dismiss();
  //   _lineController = null;
  // }
}