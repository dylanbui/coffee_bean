

// Repository cho Payment
import 'package:coffee_bean/data/model/payment_domain.dart';
import 'package:db_core/data/option_item.dart';
import 'package:flutter/material.dart';


class PaymentDomainRepository {
  final _paymentMethodRepo = PaymentMethodRepository();
  final _shippingMethodRepo = ShippingMethodRepository();

  PaymentDomainRepository();

  PaymentMethod get defaultPayment => _paymentMethodRepo.defaultItem;
  ShippingMethod get defaultShipping => _shippingMethodRepo.defaultItem;

  PaymentMethod? findPaymentByKey(String key) => _paymentMethodRepo.findByKey(key);
  ShippingMethod? findShippingByKey(String key) => _shippingMethodRepo.findByKey(key);

  List<PaymentMethod> get allPayment => _paymentMethodRepo.all;
  List<ShippingMethod> get allShipping => _shippingMethodRepo.all;
}


class PaymentMethodRepository extends DbOptionRepository<PaymentMethod> {
  PaymentMethodRepository()
      : super([
    const PaymentMethod(key: "cash", title: "Tiền mặt", isDefault: true, active: true, icon: Icons.payments_outlined),
    const PaymentMethod(key: "zalo", title: "Zalo Pay", isDefault: false, active: true, icon: Icons.account_balance_wallet_outlined),
    const PaymentMethod(key: "momo", title: "MoMo", isDefault: false, active: true, icon: Icons.account_balance_wallet_outlined),
    const PaymentMethod(key: "visa_credit", title: "Visa/Credit", isDefault: false, active: true, icon: Icons.credit_card_outlined),
  ]);
}

// --- TODO: Demo gia tri ShippingMethod

class ShippingMethodRepository extends DbOptionRepository<ShippingMethod> {
  ShippingMethodRepository()
      : super([
    const ShippingMethod(key: "cash", title: "Tiền mặt", isDefault: true, active: true, icon: Icons.payments_outlined),
    const ShippingMethod(key: "zalo", title: "Zalo Pay", isDefault: false, active: true, icon: Icons.account_balance_wallet_outlined),
    const ShippingMethod(key: "momo", title: "MoMo", isDefault: false, active: true, icon: Icons.account_balance_wallet_outlined),
    const ShippingMethod(key: "visa_credit", title: "Visa/Credit", isDefault: false, active: true, icon: Icons.credit_card_outlined),
  ]);
}