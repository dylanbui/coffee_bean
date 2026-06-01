import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/flash_utils/flash_modal_helper.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

abstract class OptionItem {
  int get id;
  String get key;
  String get title;
  bool get active;
  dynamic get icon;
}

class DefaultOptionItem extends OptionItem {
  @override
  final int id;
  @override
  final String key;
  @override
  final String title;
  @override
  final bool active;
  @override
  final dynamic icon;

  DefaultOptionItem({
    required this.id,
    required this.key,
    required this.title,
    this.active = true,
    this.icon,
  });
}

class OptionPickerModal {
  static Future<T?> show<T extends OptionItem>({
    required BuildContext context,
    required String title,
    required List<T> items,
    String? selectedKey,
  }) {
    return DbFlashModalHelper.showSmartModal<T>(
      context: context,
      title: title,
      childBuilder: (context, controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: items.map((item) => _buildOptionRow(controller, item, selectedKey == item.key)).toList(),
        );
      },
    );
  }

  static Widget _buildOptionRow<T extends OptionItem>(
    FlashController<T> controller,
    T item,
    bool isSelected,
  ) {
    return ListTile(
      enabled: item.active,
      leading: item.icon != null ? AppIcon(item.icon, color: TMLabsColor.primary, size: 24) : null,
      title: Text(
        item.title,
        style: TMLabsTextStyle.body.copyWith(
          color: item.active ? Colors.black : Colors.grey,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: TMLabsColor.primary, size: 24)
          : const Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 24),
      onTap: item.active ? () => controller.dismiss(item) : null,
    );
  }
}
