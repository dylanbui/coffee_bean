import 'package:coffee_bean/data/local/settings_app_manager/settings_app_manager.dart';
import 'package:coffee_bean/scenes/checkout_order/checkout_order_common.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';

class CheckoutOrderSummaryFallback extends StatelessWidget {
  final CheckoutItemContract contract;

  const CheckoutOrderSummaryFallback({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (contract.imageUrl != null)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: DbCachedImageWidget(
                    imageUrl: contract.imageUrl!,
                    width: 80,
                    height: 80,
                    borderRadius: 12,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contract.title,
                      style: TMLabsTextStyle.title.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      contract.subTitle,
                      style: TMLabsTextStyle.body.copyWith(color: TMLabsColor.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Số tiền gốc", style: TMLabsTextStyle.body),
              Text(
                SettingsAppManager.currentCurrency.format(contract.baseAmount),
                style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
