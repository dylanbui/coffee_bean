/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 04:10
 * Description: Wrapper cho DbFlashModalHelper để giữ tính tương thích và áp dụng style của project.
 */

import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/flash_utils/flash_modal_helper.dart';
import 'package:flutter/material.dart';

/// Re-export các Enum để bên ngoài không cần import db_core
typedef FlashModalPosition = DbFlashModalPosition;
typedef FlashFooterLayout = DbFlashFooterLayout;
typedef FlashActionsBuilder<T> = DbFlashActionsBuilder<T>;

class FlashModalHelper {
  static Future<T?> showSmartModal<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    List<Widget>? actions,
    FlashActionsBuilder<T>? actionsBuilder,
    Widget? customFooter,
    FlashFooterLayout footerLayout = FlashFooterLayout.row,
    FlashModalPosition position = FlashModalPosition.bottom,
    double maxHeightThreshold = 0.7,
    bool isPersistent = true,
  }) {
    // Định nghĩa Style cho Coffee Bean project
    final coffeeStyle = DbFlashModalStyle(
      titleStyle: TMLabsTextStyle.h2,
      borderRadius: 24.0,
      backgroundColor: Colors.white,
      barrierColor: Colors.black54,
    );

    return DbFlashModalHelper.showSmartModal<T>(
      context: context,
      title: title,
      child: child,
      actions: actions,
      actionsBuilder: actionsBuilder,
      customFooter: customFooter,
      footerLayout: footerLayout,
      position: position,
      maxHeightThreshold: maxHeightThreshold,
      isPersistent: isPersistent,
      style: coffeeStyle,
    );
  }
}

/*
  // --- CÁCH SỬ DỤNG TRONG PROJECT COFFEE BEAN ---

  // 1. Selector đơn giản (Top Modal)
  void _selectCoffeeType(BuildContext context) async {
    final result = await FlashModalHelper.showSmartModal<String>(
      context: context,
      title: "Loại hạt cà phê",
      position: FlashModalPosition.top,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: ["Arabica", "Robusta", "Moka", "Culi"].map((e) => ListTile(
          title: Text(e),
          onTap: () => Navigator.pop(context, e),
        )).toList(),
      ),
    );
    if (result != null) { // Xử lý result }
  }

  // 2. Form nhập liệu với Bàn phím (Bottom Modal)
  void _showFeedbackForm(BuildContext context) {
    FlashModalHelper.showSmartModal(
      context: context,
      title: "Gửi phản hồi",
      footerLayout: FlashFooterLayout.column,
      actions: [
        ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("GỬI")),
      ],
      child: TextField(
        maxLines: 5,
        autofocus: true,
        decoration: InputDecoration(hintText: "Nội dung..."),
      ),
    );
  }
*/
