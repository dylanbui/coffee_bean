/*
 * Created with Android Studio
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 04:00
 * Description: Base Utility hỗ trợ hiển thị Top/Bottom Modal với Custom Size và Keyboard Handling.
 * Thiết kế để dùng chung trong db_core.
 */

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

enum DbFlashModalPosition { top, bottom }

enum DbFlashFooterLayout {
  row,      // Các nút nằm ngang, dàn đều (Expanded)
  column,   // Các nút xếp chồng, chiếm trọn chiều ngang (Stretch)
  wrap,     // Tự động xuống dòng khi thiếu chỗ
  custom    // Sử dụng hoàn toàn Widget footer truyền vào
}

/// Lớp cấu hình giao diện cho Modal
class DbFlashModalStyle {
  final TextStyle titleStyle;
  final double borderRadius;
  final Color backgroundColor;
  final Color barrierColor;

  const DbFlashModalStyle({
    this.titleStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    this.borderRadius = 24.0,
    this.backgroundColor = Colors.white,
    this.barrierColor = Colors.black54,
  });
}

typedef DbFlashActionsBuilder<T> = List<Widget> Function(BuildContext context, FlashController<T> controller);

typedef DbFlashModalChildBuilder<T> = Widget Function(BuildContext context, FlashController<T> controller);

class DbFlashModalHelper {
  static Future<T?> showSmartModal<T>({
    required BuildContext context,
    required String title,
    required DbFlashModalChildBuilder<T> childBuilder,
    List<Widget>? actions,
    DbFlashActionsBuilder<T>? actionsBuilder,
    Widget? customFooter,
    DbFlashFooterLayout footerLayout = DbFlashFooterLayout.row,
    DbFlashModalPosition position = DbFlashModalPosition.bottom,
    double maxHeightThreshold = 0.7,
    bool isPersistent = true,
    DbFlashModalStyle? style,
    bool useDeferredBuild = false, // Feature mới để tối ưu jank
  }) {
    final modalStyle = style ?? const DbFlashModalStyle();

    return showFlash<T>(
      context: context,
      persistent: isPersistent,
      barrierDismissible: true,
      barrierColor: modalStyle.barrierColor,
      builder: (context, controller) {
        final mediaQuery = MediaQuery.of(context);
        final bool isTop = position == DbFlashModalPosition.top;
        final FlashPosition flashPosition = isTop ? FlashPosition.top : FlashPosition.bottom;

        return Flash(
          controller: controller,
          position: flashPosition,
          forwardAnimationCurve: Curves.fastOutSlowIn,
          reverseAnimationCurve: Curves.fastOutSlowIn,
          dismissDirections: const [FlashDismissDirection.vertical],
          child: RepaintBoundary(
            child: Align(
              alignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: !isTop ? mediaQuery.viewInsets.bottom : 0,
                ),
                child: Material( // Khôi phục Material để đảm bảo layout và style chuẩn
                  color: modalStyle.backgroundColor,
                  elevation: 4,
                  borderRadius: BorderRadius.vertical(
                    top: isTop ? Radius.zero : Radius.circular(modalStyle.borderRadius),
                    bottom: isTop ? Radius.circular(modalStyle.borderRadius) : Radius.zero,
                  ),
                  child: SizedBox(
                    width: mediaQuery.size.width,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: mediaQuery.size.height * maxHeightThreshold,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeader(title, isTop, modalStyle.titleStyle),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: useDeferredBuild
                                  ? FutureBuilder(
                                      future: Future.delayed(const Duration(milliseconds: 150)),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState != ConnectionState.done) {
                                          return const SizedBox(
                                            height: 80,
                                            child: Center(child: CircularProgressIndicator.adaptive(strokeWidth: 2)),
                                          );
                                        }
                                        return childBuilder.call(context, controller);
                                      },
                                    )
                                  : childBuilder.call(context, controller),
                            ),
                          ),
                          _buildFooter(footerLayout, actionsBuilder?.call(context, controller) ?? actions, customFooter),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildHeader(String title, bool isTop, TextStyle titleStyle) {
    return SafeArea(
      top: isTop,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                title,
                style: titleStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildFooter(DbFlashFooterLayout layout, List<Widget>? actions, Widget? customFooter) {
    if (customFooter != null) return customFooter;
    if (actions == null || actions.isEmpty) return const SizedBox(height: 12);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: _getFooterLayout(layout, actions),
    );
  }

  static Widget _getFooterLayout(DbFlashFooterLayout layout, List<Widget> actions) {
    switch (layout) {
      case DbFlashFooterLayout.column:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: actions.map((a) => Padding(padding: const EdgeInsets.only(bottom: 8), child: a)).toList(),
        );
      case DbFlashFooterLayout.row:
        return Row(
          children: actions.map((a) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: a))).toList(),
        );
      case DbFlashFooterLayout.wrap:
      default:
        return Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.end,
          children: actions,
        );
    }
  }
}
