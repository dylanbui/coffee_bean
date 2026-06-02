import 'package:db_core/data/option_item.dart';

// Domain model cho PaymentMethod, implement trực tiếp OptionItem
class PaymentMethod implements DbOptionItem {
  @override
  final String key;
  @override
  final String title;
  @override
  final bool isDefault;
  @override
  final bool active;
  @override
  final dynamic icon;

  const PaymentMethod({
    required this.key, // có thể là String hoặc int
    required this.title,
    this.isDefault = false,
    this.active = true,
    this.icon,
  });
}


// --- TODO: Demo gia tri ShippingMethod

// Shipping method
class ShippingMethod implements DbOptionItem {
  @override
  final String key;
  @override
  final String title;
  @override
  final bool isDefault;
  @override
  final bool active;
  @override
  final dynamic icon;

  const ShippingMethod({
    required this.key,
    required this.title,
    this.isDefault = false,
    this.active = true,
    this.icon,
  });
}