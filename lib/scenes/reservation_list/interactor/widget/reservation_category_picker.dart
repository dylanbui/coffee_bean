import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

class ReservationCategoryPicker extends StatelessWidget {
  final List<TblCategory> categories;
  final TblCategory? selectedCategory;
  final FlashController<TblCategory?> controller;

  const ReservationCategoryPicker({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final allCats = [
      TblCategory()
        ..serverId = -1
        ..name = "Tất cả các loại",
      ...categories
    ];

    int selectedIndex = allCats.indexWhere(
        (c) => (c.serverId == (selectedCategory?.serverId ?? -1)));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: GroupButton<TblCategory>(
        buttons: allCats,
        onSelected: (cat, index, isSelected) {
          controller.dismiss(cat.serverId == -1 ? null : cat);
        },
        controller: GroupButtonController(selectedIndex: selectedIndex),
        buttonBuilder: (selected, cat, _) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: selected ? TMLabsColor.primary : TMLabsColor.bgLight,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Center(
              child: Text(
                cat.name,
                style: TMLabsTextStyle.bodyBold.copyWith(
                  color: selected ? Colors.white : TMLabsColor.accent,
                ),
              ),
            ),
          );
        },
        options: const GroupButtonOptions(
          mainGroupAlignment: MainGroupAlignment.center,
        ),
      ),
    );
  }
}
