import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_event_state.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/number_to_vietnamese.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailFooter extends StatelessWidget {
  final ProductDetailInteractor interactor;

  const ProductDetailFooter({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailInteractor, ProductDetailState>(
      builder: (context, state) {
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 110,
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10 + MediaQuery.of(context).padding.bottom),
            decoration: BoxDecoration(
              color: TMLabsColor.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      NumberToVietnamese.formatNumber(state.totalPrice),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: TMLabsColor.primary),
                    ),
                    _buildStepping(state),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: "Thêm giỏ hàng",
                        onPressed: state.isAddingToCart ? null : () => interactor.addToCart(),
                        style: TMLabsButtonStyle.outline,
                        isLoading: state.isAddingToCart,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: AppButton(
                        text: "MUA NGAY",
                        onPressed: state.isAddingToCart ? null : () => interactor.buyNow(),
                        style: TMLabsButtonStyle.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepping(ProductDetailState state) {
    return Row(
      children: [
        TapEffect(
          onTap: () => interactor.updateQuantity(-1),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: TMLabsColor.primary.withValues(alpha: 0.8), width: 1.5),
            ),
            child: const Icon(Icons.remove, size: 18, color: TMLabsColor.primary),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          decoration: BoxDecoration(
            color: TMLabsColor.lightGrey.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "${state.quantity}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: TMLabsColor.primary),
          ),
        ),
        const SizedBox(width: 10),
        TapEffect(
          onTap: () => interactor.updateQuantity(1),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: TMLabsColor.primary,
            ),
            child: const Icon(Icons.add, size: 18, color: TMLabsColor.white),
          ),
        ),
      ],
    );
  }
}
