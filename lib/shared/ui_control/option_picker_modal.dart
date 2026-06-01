import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/flash_utils/flash_modal_helper.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

// Base abstraction cho mọi option item
abstract class OptionItem {
  String get key;    // unique string key
  String get title;  // tên hiển thị
  bool get active;   // có cho phép chọn không
  dynamic get icon;  // icon asset hoặc widget
}

// Default implementation, user for simple Modal
class DefaultOptionItem extends OptionItem {
  @override
  final String key;
  @override
  final String title;
  @override
  final bool active;
  @override
  final dynamic icon;

  DefaultOptionItem({
    required dynamic key, // có thể là String hoặc int
    required this.title,
    this.active = true,
    this.icon,
  }) : key = key is int ? key.toString() : key;
}

// Repository pattern để quản lý danh sách hardcode
class OptionRepository<T extends OptionItem> {
  final List<T> items;

  const OptionRepository(this.items);

  List<T> get all => items;

  T get defaultItem => items.firstWhere((i) => i.active, orElse: () => items.first);

  T? findByKey(String key) => items.firstWhere((i) => i.key == key, orElse: () => defaultItem);
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
