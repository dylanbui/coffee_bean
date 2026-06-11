import 'package:db_core/utils/app_button.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:coffee_bean/scenes/app_landing/shopping/interactor/shopping_interactor.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/number_to_vietnamese.dart';
import 'package:flutter/material.dart';

class ShoppingFooter extends StatelessWidget {
  final ShoppingInteractor interactor;

  const ShoppingFooter({super.key, required this.interactor});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TblCartItem>>(
      stream: interactor.cartService.cartStream,
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];
        final totalQuantity = items.fold(0, (sum, item) => sum + item.quantity);
        final totalPrice = items.fold(0.0, (sum, item) => sum + item.totalPrice);

        return Positioned(
          left: 16,
          right: 16,
          bottom: 10,
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: TMLabsColor.navy,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: AppIcon(AppAssets.icons.icShopping, color: TMLabsColor.white, size: 28),
                    ),
                    if (totalQuantity > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: TMLabsColor.red, shape: BoxShape.circle),
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          child: Text(
                            "$totalQuantity",
                            style: TMLabsTextStyle.small.copyWith(color: TMLabsColor.white, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        NumberToVietnamese.formatNumber(totalPrice),
                        style: TMLabsTextStyle.title.copyWith(color: TMLabsColor.white, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Ưu đãi đã áp dụng",
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                AppButton(
                  text: "THANH TOÁN",
                  width: 110,
                  height: 38,
                  style: TMLabsButtonStyle.primary.copyWith(
                    backgroundColor: TMLabsColor.grey,
                    textColor: TMLabsColor.white,
                    borderRadius: 19,
                    textStyle: TMLabsTextStyle.small.copyWith(fontWeight: FontWeight.bold, color: TMLabsColor.white),
                  ),
                  onPressed: () {
                    if (totalQuantity > 0) {
                      interactor.checkout();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
