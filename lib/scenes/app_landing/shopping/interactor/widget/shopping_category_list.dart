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
      width: 80, // Fixed width as requested
      color: Colors.white, // Parent background can be white
      child: ListView.builder(
        controller: controller,
        padding: const EdgeInsets.symmetric(vertical: 0),
        itemCount: state.categories.length,
        itemBuilder: (context, index) {
          final category = state.categories[index];
          bool isSelected = state.selectedCategoryIndex == index;
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
                    category.image ?? AppAssets.icons.icHome,
                    // Active: #8D95A0, Deactive: #CECCCD (TMLabsColor.lightGrey)
                    color: isSelected ? const Color(0xFF8D95A0) : TMLabsColor.lightGrey,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      category.name ?? "",
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.2,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        // Match icon color for consistency or keep as is? 
                        // User only mentioned icon color, but usually text follows.
                        color: isSelected ? const Color(0xFF8D95A0) : TMLabsColor.grey,
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
