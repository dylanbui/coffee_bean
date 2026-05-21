import 'package:coffee_bean/core/utils/app_button.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_interactor.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/search_bar.dart';
import 'package:flutter/material.dart';

class ShoppingHeader extends StatelessWidget {
  final ShoppingInteractor interactor;
  final ShoppingState state;

  const ShoppingHeader({
    super.key,
    required this.interactor,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 0),
      child: Row(
        children: [
          AppButton(
            text: "Tự lấy",
            width: 100,
            height: 40,
            style: TMLabsStyle.primaryButton.copyWith(
              backgroundColor: TMLabsColor.navy,
              borderRadius: 20,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppSearchBar(
              onSearch: (value) => interactor.onSearchChanged(value),
              hintText: "Tìm kiếm sản phẩm",
              minLength: 1,
              backgroundColor: Colors.grey[100],
              leftIcon: AppAssets.icons.icSearch,
              borderRadius: 20,
            ),
          ),
        ],
      ),
    );
  }
}
