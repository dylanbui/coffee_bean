import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/utils/currency_utils.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/utils/widget/cached_image_widget.dart';
import 'package:flutter/material.dart';

class CartCheckoutItemsView extends StatelessWidget {
  final List<TblCartItem> items;

  const CartCheckoutItemsView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 32, color: Color(0xFFF5F5F5)),
        itemBuilder: (context, index) {
          final item = items[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DbCachedImageWidget(imageUrl: item.image ?? '', width: 80, height: 80, borderRadius: 12),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name.toUpperCase(), style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.w900, fontSize: 14)),
                    if (item.selectedOptions != null)
                      Text(
                        item.selectedOptions!.map((e) => e.optionName).join(' / '),
                        style: TMLabsTextStyle.caption.copyWith(color: Colors.grey),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("x${item.quantity}", style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
                        Text(item.totalPrice.toFormatPrice(), style: TMLabsTextStyle.body.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
