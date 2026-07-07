import 'package:coffee_bean/data/model/response/system/dictionary_data.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

class CourseCategoryPicker extends StatelessWidget {
  final List<DictionaryData> categories;
  final DictionaryData? selectedCategory;
  final FlashController<DictionaryData?> controller;

  const CourseCategoryPicker({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final allCats = [
      DictionaryData(id: 0, label: "Tất cả các loại", value: "", dictType: ""),
      ...categories
    ];

    int selectedIndex = allCats.indexWhere(
        (c) => (c.id == (selectedCategory?.id ?? 0)));

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GroupButton<DictionaryData>(
        buttons: allCats,
        onSelected: (cat, index, isSelected) {
          controller.dismiss(cat.id == 0 ? null : cat);
        },
        controller: GroupButtonController(selectedIndex: selectedIndex),
        buttonBuilder: (selected, cat, _) {
          return Container(
            width: double.infinity,
            height: 44,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: selected ? TMLabsColor.primary : TMLabsColor.bgLight,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Center(
              child: Text(
                cat.label,
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
