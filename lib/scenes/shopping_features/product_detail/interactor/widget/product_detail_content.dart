import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_event_state.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:flutter_html/flutter_html.dart';

class ProductDetailContent extends StatelessWidget {
  final ProductDetailInteractor interactor;

  const ProductDetailContent({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailInteractor, ProductDetailState>(
      buildWhen: (p, c) => p.product != c.product || p.selectedOptions != c.selectedOptions,
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
              const SizedBox(height: 16),
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
}
