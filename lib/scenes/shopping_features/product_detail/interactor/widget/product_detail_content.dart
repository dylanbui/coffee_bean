import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_event_state.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:group_button/group_button.dart';
import 'package:coffee_bean/data/model/product.dart';

class ProductDetailContent extends StatelessWidget {
  final ProductDetailInteractor interactor;

  const ProductDetailContent({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailInteractor, ProductDetailState>(
      buildWhen: (p, c) => p.product != c.product || p.selectedOptions != c.selectedOptions || p.skuGroups != c.skuGroups,
      builder: (context, state) {
        final product = state.product;
        if (product == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name.toUpperCase(),
                style: TMLabsTextStyle.h1.copyWith(color: TMLabsColor.primary),
              ),
              const SizedBox(height: 8),
              Text(
                product.introduction,
                style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey),
              ),
              const SizedBox(height: 24),

              // Render SKU Groups
              ...state.skuGroups.map((group) => _buildSkuGroup(context, state, group)),

              const SizedBox(height: 8),
              Text(
                "Mô tả sản phẩm",
                style: TMLabsTextStyle.h2,
              ),
              const SizedBox(height: 8),
              Html(
                data: product.description,
                style: TMLabsTextStyle.htmlStyle,
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkuGroup(BuildContext context, ProductDetailState state, SkuGroup group) {
    final selectedIndex = group.options.indexWhere((o) => state.selectedOptions[group.propertyId] == o.valueId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.propertyName,
          style: TMLabsTextStyle.title.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GroupButton<SkuProperty>(
          buttons: group.options,
          controller: GroupButtonController(selectedIndex: selectedIndex),
          onSelected: (option, index, isSelected) {
            // Logic "Mặc định": Nếu chỉ có 1 option và là mặc định, không cho phép thay đổi
            if (group.options.length == 1 && option.valueName == "Mặc định") return;
            interactor.selectOption(group.propertyId, option.valueId);
          },
          buttonBuilder: (isSelected, option, context) {
            final isDisable = group.options.length == 1 && option.valueName == "Mặc định";
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : TMLabsColor.lightGrey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: isDisable ? Border.all(color: TMLabsColor.grey.withValues(alpha: 0.2)) : null,
              ),
              child: Text(
                option.valueName,
                style: TMLabsTextStyle.body.copyWith(
                  color: isSelected ? Colors.white : TMLabsColor.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
          options: const GroupButtonOptions(
            mainGroupAlignment: MainGroupAlignment.start,
            groupingType: GroupingType.wrap,
            spacing: 12,
            runSpacing: 12,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
