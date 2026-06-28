import 'package:coffee_bean/scenes/checkout_order/checkout_order_common.dart';
import 'package:db_core/commons_constants.dart';
import 'package:flutter/material.dart';

class ActivityCheckoutItem extends CheckoutItemContract {
  final int activityId;
  final String activityTitle;
  final String activityAddress;
  final String? activityImageUrl;
  final double activityPrice;

  ActivityCheckoutItem({
    required this.activityId,
    required this.activityTitle,
    required this.activityAddress,
    this.activityImageUrl,
    required this.activityPrice,
  });

  @override
  double get baseAmount => activityPrice;

  @override
  Widget? buildSummaryWidget(BuildContext context) {
    // Trả về null để sử dụng giao diện mặc định của Checkout module
    return null;
  }

  @override
  String get category => "ACTIVITY";

  @override
  Dictionary get extraData => {
        "activity_id": activityId,
      };

  @override
  String? get imageUrl => activityImageUrl;

  @override
  String get subTitle => activityAddress;

  @override
  String get title => activityTitle;
}
