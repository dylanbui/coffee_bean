/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 1/5/26 - 22:36
 * To change this template use File | Settings | File Templates.
 */

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

/// **************************************************************************
/// FLASH MODAL UTILITY
/// Author: Gemini / Coffee Bean Project
/// Description: Hỗ trợ hiển thị Top/Bottom Modal với Custom Size và Keyboard Handling
/// **************************************************************************

enum FlashModalPosition { top, bottom }

enum FlashFooterLayout {
    row,      // Các nút nằm ngang, dàn đều (Expanded)
    column,   // Các nút xếp chồng, chiếm trọn chiều ngang (Stretch)
    wrap,     // Tự động xuống dòng khi thiếu chỗ
    custom    // Sử dụng hoàn toàn Widget footer truyền vào
}

/// **************************************************************************
/// FLASH MODAL UTILITY (FIXED FOR 3.1.1)
/// Description: Loại bỏ hoàn toàn 'behavior', sử dụng Align để điều khiển vị trí.
/// **************************************************************************

class FlashModalHelper {
    static Future<T?> showSmartModal<T>({
        required BuildContext context,
        required String title,
        required Widget child,
        List<Widget>? actions,
        Widget? customFooter,
        FlashFooterLayout footerLayout = FlashFooterLayout.row,
        FlashModalPosition position = FlashModalPosition.bottom,
        double maxHeightThreshold = 0.7,
        bool isPersistent = true,
    }) {
        return showFlash<T>(
            context: context,
            persistent: isPersistent,
            barrierDismissible: true,
            barrierColor: Colors.black54,
            builder: (context, controller) {
                final mediaQuery = MediaQuery.of(context);
                final bool isTop = position == FlashModalPosition.top;

                return Flash(
                    controller: controller,
                    child: Align(
                        alignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
                        child: Padding(
                            // Đẩy toàn bộ Modal lên khi bàn phím xuất hiện
                            padding: EdgeInsets.only(
                                bottom: !isTop ? mediaQuery.viewInsets.bottom : 0,
                            ),
                            child: Material(
                                color: Colors.white,
                                elevation: 8,
                                borderRadius: BorderRadius.vertical(
                                    top: isTop ? Radius.zero : const Radius.circular(24),
                                    bottom: isTop ? const Radius.circular(24) : Radius.zero,
                                ),
                                child: SizedBox(
                                    width: mediaQuery.size.width, // Đảm bảo luôn tràn ngang
                                    child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxHeight: mediaQuery.size.height * maxHeightThreshold,
                                        ),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                                // Header xử lý SafeArea cho Top Modal
                                                _buildHeader(title, isTop),

                                                Flexible(
                                                    child: SingleChildScrollView(
                                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                                        child: child,
                                                    ),
                                                ),

                                                _buildFooter(footerLayout, actions, customFooter),

                                                // XỬ LÝ CHO iOS: Đệm cho thanh Home Indicator
                                                if (!isTop)
                                                    SizedBox(
                                                        height: mediaQuery.padding.bottom > 0
                                                            ? mediaQuery.padding.bottom
                                                            : 16.0,
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
        );
    }

    static Widget _buildHeader(String title, bool isTop) {
        return SafeArea(
            top: isTop, // Chỉ SafeArea phía trên nếu là Top Modal
            bottom: false,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                    children: [
                        Expanded(
                            child: Text(
                                title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    static Widget _buildFooter(FlashFooterLayout layout, List<Widget>? actions, Widget? customFooter) {
        if (customFooter != null) return customFooter;
        if (actions == null || actions.isEmpty) return const SizedBox(height: 12);

        return Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: _getFooterLayout(layout, actions),
        );
    }

    static Widget _getFooterLayout(FlashFooterLayout layout, List<Widget> actions) {
        switch (layout) {
            case FlashFooterLayout.column:
                return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: actions.map((a) => Padding(padding: const EdgeInsets.only(bottom: 8), child: a)).toList(),
                );
            case FlashFooterLayout.row:
                return Row(
                    children: actions.map((a) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: a))).toList(),
                );
            case FlashFooterLayout.wrap:
            default:
                return Wrap(
                    spacing: 12, runSpacing: 8,
                    alignment: WrapAlignment.end,
                    children: actions,
                );
        }
    }
}

/// **************************************************************************
/// EXAMPLES - CÁCH SỬ DỤNG TRONG PROJECT
/// **************************************************************************

/*
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

  // 3. Multi-selection với StatefulBuilder
  void _selectToppings(BuildContext context) async {
    List<String> selected = [];
    final result = await FlashModalHelper.showSmartModal<List<String>>(
      context: context,
      title: "Chọn Toppings",
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("HỦY")),
        ElevatedButton(onPressed: () => Navigator.pop(context, selected), child: Text("XÁC NHẬN")),
      ],
      child: StatefulBuilder(
        builder: (context, setModalState) {
          return Column(
            children: ["Trân châu", "Kem muối", "Thạch"].map((t) => CheckboxListTile(
              title: Text(t),
              value: selected.contains(t),
              onChanged: (v) => setModalState(() => v! ? selected.add(t) : selected.remove(t)),
            )).toList(),
          );
        },
      ),
    );
  }
*/