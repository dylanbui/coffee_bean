

// Repository cho Payment
import 'package:coffee_bean/shared/ui_control/option_picker_modal.dart';
import 'package:flutter/material.dart';

// Domain model cho PaymentMethod, implement trực tiếp OptionItem
class PaymentMethod implements OptionItem {
  @override
  final String key;
  @override
  final String title;
  @override
  final bool active;
  @override
  final dynamic icon;

  const PaymentMethod({
    required this.key, // có thể là String hoặc int
    required this.title,
    this.active = false,
    this.icon,
  });
}

class PaymentMethodRepository extends OptionRepository<PaymentMethod> {
  PaymentMethodRepository()
      : super([
    const PaymentMethod(key: "cash", title: "Tiền mặt", active: true, icon: Icons.payments_outlined),
    const PaymentMethod(key: "zalo", title: "Zalo Pay", active: true, icon: Icons.account_balance_wallet_outlined),
    const PaymentMethod(key: "momo", title: "MoMo", active: true, icon: Icons.account_balance_wallet_outlined),
    const PaymentMethod(key: "visa_credit", title: "Visa/Credit", active: true, icon: Icons.credit_card_outlined),
  ]);
}

// --- TODO: Demo gia tri ShippingMethod

// Shipping method
class ShippingMethod implements OptionItem {
  @override
  final String key;
  @override
  final String title;
  @override
  final bool active;
  @override
  final dynamic icon;

  const ShippingMethod({
    required this.key,
    required this.title,
    this.active = false,
    this.icon,
  });
}

class ShippingMethodRepository extends OptionRepository<ShippingMethod> {
  ShippingMethodRepository()
      : super([
    const ShippingMethod(key: "cash", title: "Cash", active: true, icon: Icons.credit_card_outlined),
    const ShippingMethod(key: "zalo", title: "ZaloPay", icon: Icons.credit_card_outlined),
    const ShippingMethod(key: "momo", title: "MoMo", icon: Icons.credit_card_outlined),
    const ShippingMethod(key: "visa_credit", title: "Visa/Credit", icon: Icons.credit_card_outlined),
  ]);
}