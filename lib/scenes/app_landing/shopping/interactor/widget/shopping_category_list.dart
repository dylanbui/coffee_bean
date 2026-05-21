import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_event_state.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:flutter/material.dart';

class ShoppingCategoryList extends StatelessWidget {
  final ShoppingState state;
  final ScrollController controller;
  final Function(int) onCategoryTap;

  const ShoppingCategoryList({
    super.key,
    required this.state,
    required this.controller,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90, // Increased width
      color: TMLabsColor.lightGrey.withValues(alpha: 0.15), // Slightly darker background
      child: ListView.builder(
        controller: controller,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: state.categories.length,
        itemBuilder: (context, index) {
          final category = state.categories[index];
          bool isSelected = state.selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => onCategoryTap(index),
            child: Container(
              height: 96,
              margin: const EdgeInsets.only(bottom: 4), // Space between items
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                border: isSelected ? const Border(left: BorderSide(color: TMLabsColor.primary, width: 4)) : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: isSelected ? TMLabsColor.primary.withValues(alpha: 0.1) : TMLabsColor.lightGrey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: AppIcon(
                        category.image ?? AppAssets.icons.icHome,
                        color: isSelected ? TMLabsColor.primary : TMLabsColor.grey,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      category.name ?? "",
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.2,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? TMLabsColor.primary : TMLabsColor.grey,
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
