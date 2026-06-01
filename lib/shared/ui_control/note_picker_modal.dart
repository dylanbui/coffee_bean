import 'package:coffee_bean/utils/flash_utils/flash_dialog_helper.dart';
import 'package:flutter/material.dart';

class NotePickerModal {
  static Future<String?> show({
    required BuildContext context,
    required String title,
    String? content,
    String? initialValue,
    String hintText = "Nhập ghi chú...",
    int maxLength = 200,
    int maxLines = 4,
  }) {
    final controller = TextEditingController(text: initialValue);
    
    return FlashDialogHelper.show<String>(
      context: context,
      title: title,
      content: content,
      barrierDismissible: false,
      body: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                maxLength: maxLength,
                maxLines: maxLines,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: const OutlineInputBorder(),
                  counterText: "", // Hide default counter
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Còn lại: ${maxLength - controller.text.length} ký tự",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        FlashDialogAction(label: "Bỏ Qua", value: "cancel"),
        FlashDialogAction(label: "Ghi", value: "save"),
      ],
    ).then((result) {
      if (result == "save") {
        return controller.text;
      }
      return null;
    });
  }
}
