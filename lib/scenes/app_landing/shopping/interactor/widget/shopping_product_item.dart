import 'package:db_core/utils/tap_effect.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_interactor.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/widget/cached_image_widget.dart';
import 'package:coffee_bean/utils/number_to_vietnamese.dart';
import 'package:flutter/material.dart';

class ShoppingProductItem extends StatelessWidget {
  final TblFood product;
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
                    imageUrl: product.mainImage ?? "",
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorWidget: Image.asset(
                      AppAssets.images.imgNoImage,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
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
              bottom: 0,
              child: StreamBuilder<List<TblCartItem>>(
                stream: interactor.cartService.cartStream,
                builder: (context, snapshot) {
                  final cartItems = snapshot.data ?? [];
                  // Tìm sản phẩm này trong giỏ hàng
                  final cartItem = cartItems.where((item) => 
                    item.serverId == product.serverId && item.type == "FOOD"
                  ).firstOrNull;
                  final quantity = cartItem?.quantity ?? 0;

                  return TapEffect(
                    onTap: () => interactor.addToCart(product),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4, right: 4),
                          child: AppIcon(AppAssets.icons.icPlusCycleWhite, size: 36),
                        ),
                        if (quantity > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: TMLabsColor.red,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
