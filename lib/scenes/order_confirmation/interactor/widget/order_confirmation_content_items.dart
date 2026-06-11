import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/number_to_vietnamese.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderConfirmationContentItems extends StatelessWidget {
  final List<TblCartItem> items;

  const OrderConfirmationContentItems({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = items[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DbCachedImageWidget(
                imageUrl: item.image ?? '',
                width: 90,
                height: 90,
                borderRadius: 16,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name.toUpperCase(),
                        style: TMLabsTextStyle.title.copyWith(fontWeight: FontWeight.w900, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.selectedOptions != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            item.selectedOptions!.map((e) => e.optionName).join(' / '),
                            style: TMLabsTextStyle.caption.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("x${item.quantity}",
                              style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
                          Text(
                            NumberToVietnamese.formatNumber(item.totalPrice),
                            style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

}
