import 'package:coffee_bean/config/constants.dart';
import 'package:coffee_bean/data/model/category.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ShoppingCategoryList extends StatelessWidget {
  final List<Category> categories;
  final int selectedIndex;
  final ItemScrollController itemScrollController;
  final Function(int) onCategoryTap;

  const ShoppingCategoryList({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.itemScrollController,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, // Fixed width as requested
      color: Colors.white, // Parent background can be white
      child: ScrollablePositionedList.builder(
        itemScrollController: itemScrollController,
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onCategoryTap(index),
            child: Container(
              width: 80,
              height: 110, // Fixed height as requested
              margin: const EdgeInsets.only(bottom: 10), // Spacing between items
              decoration: BoxDecoration(
                color: TMLabsColor.lightGrey.withValues(alpha: 0.5), // Background for all items
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIcon(
                    CategoryIcons.getIcon(category.id),
                    // Active: #8D95A0, Deactive: #CECCCD (TMLabsColor.lightGrey)
                    color: isSelected ? TMLabsColor.grey : TMLabsColor.lightGrey,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.2,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? TMLabsColor.grey : TMLabsColor.lightGrey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
