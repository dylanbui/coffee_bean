import 'package:coffee_bean/data/model/payment_domain.dart';
import 'package:coffee_bean/data/model/response/trade/store_model.dart';
import 'package:coffee_bean/features/checkout_order/checkout_order_common.dart';
import 'package:coffee_bean/features/cart_workflow/widgets/cart_checkout_header_view.dart';
import 'package:coffee_bean/features/cart_workflow/widgets/cart_checkout_items_view.dart';
import 'package:coffee_bean/features/cart_workflow/widgets/cart_checkout_options_view.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:db_core/commons_constants.dart';
import 'package:flutter/material.dart';

class AppCartCheckoutContract extends CheckoutItemContract {
  final List<TblCartItem> items;
  final StoreModel? store;

  final ValueNotifier<String> noteNotifier = ValueNotifier("");
  final ValueNotifier<DeliveryMethod> deliveryMethodNotifier = ValueNotifier(DeliveryMethod.dineIn);

  AppCartCheckoutContract({required this.items, this.store});

  @override
  String get title => store?.name ?? "Cửa hàng Coffee Bean";
  
  @override
  String get subTitle => store?.fullAddress ?? "";

  @override
  String? get imageUrl => store?.logo;

  @override
  double get baseAmount => items.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  String get category => "FOOD";

  @override
  Dictionary get extraData => {
    'store_id': store?.id,
    'note': noteNotifier.value,
    'delivery_method': deliveryMethodNotifier.value.name,
    'items': items.map((e) => {'sku_id': e.skuId, 'quantity': e.quantity}).toList(),
  };

  @override
  Widget? buildSummaryWidget(BuildContext context) {
    return Column(
      children: [
        CartCheckoutHeaderView(store: store),
        const SizedBox(height: 12),
        CartCheckoutItemsView(items: items),
      ],
    );
  }

  @override
  Widget? buildOptionsWidget(BuildContext context) {
    return CartCheckoutOptionsView(
      noteNotifier: noteNotifier,
      deliveryMethodNotifier: deliveryMethodNotifier,
    );
  }

  @override
  void dispose() {
    noteNotifier.dispose();
    deliveryMethodNotifier.dispose();
    super.dispose();
  }
}
