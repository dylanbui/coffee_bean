import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/food_detail_event_state.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/food_detail_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';

class FoodDetailContent extends StatelessWidget {
  final FoodDetailInteractor interactor;

  const FoodDetailContent({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodDetailInteractor, FoodDetailState>(
      buildWhen: (p, c) => p.product != c.product || p.selectedOptions != c.selectedOptions,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.product.name.toUpperCase(),
                style: TMLabsTextStyle.h1.copyWith(color: Colors.black),
              ),
              Text(
                state.product.description ?? "",
                style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
              ),
              const SizedBox(height: 10),
              if (state.product.properties != null)
                ...state.product.properties!.map((prop) => _buildPropertySelector(prop, state, context)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPropertySelector(TblProductProperty prop, FoodDetailState state, BuildContext context) {
    final options = prop.options ?? [];
    if (options.isEmpty) return const SizedBox.shrink();

    final selectedOption = state.selectedOptions[prop.serverId];
    int selectedIndex = options.indexOf(selectedOption ?? options.first);
    if (selectedIndex == -1) selectedIndex = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          prop.groupName,
          style: TMLabsTextStyle.h2,
        ),
        const SizedBox(height: 12),
        GroupButton<TblProductOption>(
          options: GroupButtonOptions(
            selectedColor: TMLabsColor.primary,
            unselectedColor: TMLabsColor.lightGrey.withValues(alpha: 0.5),
            selectedTextStyle: TMLabsTextStyle.body.copyWith(color: Colors.white),
            unselectedTextStyle: TMLabsTextStyle.body,
            borderRadius: BorderRadius.circular(20),
            spacing: 10,
            runSpacing: 10,
            groupingType: GroupingType.wrap,
            direction: Axis.horizontal,
            mainGroupAlignment: MainGroupAlignment.start,
          ),
          buttons: options,
          buttonBuilder: (selected, option, context) {
            return IgnorePointer(
              ignoring: !option.isAvailable,
              child: Opacity(
                opacity: option.isAvailable ? 1.0 : 0.3,
                child: Container(
                  width: (MediaQuery.of(context).size.width - 60) / 3,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? TMLabsColor.primary : TMLabsColor.lightGrey.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    option.name,
                    style: TextStyle(
                      color: selected ? Colors.white : TMLabsColor.primary,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
          onSelected: (option, index, isSelected) {
            interactor.selectOption(prop.serverId, option);
          },
          controller: GroupButtonController(selectedIndex: selectedIndex),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
