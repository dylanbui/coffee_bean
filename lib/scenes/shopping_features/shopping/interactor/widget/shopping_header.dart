import 'package:coffee_bean/data/local/store_manager/store_manager.dart';
import 'package:db_core/utils/app_button.dart';
import 'package:db_core/utils/tap_effect.dart';
import 'package:coffee_bean/scenes/shopping_features/shopping/interactor/shopping_interactor.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/search_bar.dart';
import 'package:coffee_bean/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class ShoppingHeader extends StatelessWidget {
  final ShoppingInteractor interactor;

  const ShoppingHeader({
    super.key,
    required this.interactor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Utils.getTopPadding(context, extraTop: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppButton(
                text: "Tự lấy",
                width: 100,
                height: 40,
                style: TMLabsButtonStyle.primary.copyWith(
                  backgroundColor: TMLabsColor.navy,
                  borderRadius: 20,
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppSearchBar(
                  onSearch: (value) => interactor.onSearchChanged(value),
                  hintText: "Tìm kiếm sản phẩm",
                  minLength: 1,
                  backgroundColor: TMLabsColor.bgLight,
                  leftIcon: AppAssets.icons.icSearch,
                  borderRadius: 20,
                  height: 40,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListenableBuilder(
            listenable: StoreManager(),
            builder: (context, child) {
              final storeName = StoreManager().selectedStore?.name ?? "";
              return TapEffect(
                onTap: () => interactor.openStoreList(),
                child: Row(
                  children: [
                    Text(
                      "Cửa hàng",
                      style: TMLabsTextStyle.bodyBold.copyWith(
                        fontSize: 16,
                        color: TMLabsColor.navy,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: TMLabsColor.navy,
                    ),
                    if (storeName.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final textStyle = TMLabsTextStyle.bodyBold.copyWith(
                              fontSize: 16,
                              color: TMLabsColor.navy,
                              height: 1.3,
                            );

                            final textPainter = TextPainter(
                              text: TextSpan(text: storeName, style: textStyle),
                              maxLines: 1,
                              textDirection: TextDirection.ltr,
                            )..layout(maxWidth: double.infinity);

                            if (textPainter.width > constraints.maxWidth) {
                              return SizedBox(
                                height: 22,
                                child: Marquee(
                                  text: storeName,
                                  style: textStyle,
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  blankSpace: 50.0,
                                  velocity: 30.0,
                                  pauseAfterRound: const Duration(seconds: 3),
                                  accelerationDuration: const Duration(seconds: 1),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration: const Duration(milliseconds: 500),
                                  decelerationCurve: Curves.easeOut,
                                ),
                              );
                            }

                            return Text(
                              storeName,
                              style: textStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
