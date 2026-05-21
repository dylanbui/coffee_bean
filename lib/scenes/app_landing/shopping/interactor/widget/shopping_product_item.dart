import 'package:coffee_bean/core/utils/tap_effect.dart';
import 'package:coffee_bean/data/local/live_service/model/cart_item.dart';
import 'package:coffee_bean/data/model/product.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_interactor.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/widget/cached_image_widget.dart';
import 'package:coffee_bean/utils/number_to_vietnamese.dart';
import 'package:flutter/material.dart';

class ShoppingProductItem extends StatelessWidget {
  final Product product;
  final ShoppingInteractor interactor;
  final double height;

  const ShoppingProductItem({
    super.key,
    required this.product,
    required this.interactor,
    this.height = 110.0,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CartItem>>(
      stream: interactor.cartService.cartStream,
      builder: (context, snapshot) {
        final cartItems = snapshot.data ?? [];
        final quantity = cartItems
            .where((item) => item.product.id == product.id)
            .fold(0, (sum, item) => sum + item.quantity);

        return TapEffect(
          onClickScale: 0.9,
          onTap: () => interactor.routeToProductDetail(product),
          child: Container(
            height: height,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: TMLabsColor.lightGrey.withValues(alpha: 0.5), // Darker background
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedImageWidget(
                        imageUrl: product.images?.first ?? "",
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            product.title ?? "",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            NumberToVietnamese.formatNumber(product.price, "đ") ?? "",
                            style: const TextStyle(color: TMLabsColor.grey, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40), // Space for add button
                  ],
                ),
                Positioned(
                  right: 0,
                  bottom: -4,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      IconButton(
                        icon: AppIcon(AppAssets.icons.icPlusCycleWhite, size: 32),
                        onPressed: () => interactor.addToCart(product),
                      ),
                      if (quantity > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: TMLabsColor.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                            child: Text(
                              "$quantity",
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
