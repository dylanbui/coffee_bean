import 'package:coffee_bean/data/model/response/product/product.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_event_state.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_interactor.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailSuggestedSection extends StatelessWidget {
  final ProductDetailInteractor interactor;

  const ProductDetailSuggestedSection({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailInteractor, ProductDetailState>(
      buildWhen: (p, c) => p.suggestedProducts != c.suggestedProducts,
      builder: (context, state) {
        if (state.suggestedProducts.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Sản phẩm gợi ý",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                scrollDirection: Axis.horizontal,
                itemCount: state.suggestedProducts.length,
                itemBuilder: (context, index) {
                  final item = state.suggestedProducts[index];
                  return Container(
                    width: 130,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: DbCachedImageWidget(
                            imageUrl: item.picUrl,
                            height: 120,
                            width: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item.formattedPrice(),
                          style: const TextStyle(color: TMLabsColor.grey, fontSize: 11),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
