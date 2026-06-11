import 'package:db_core/data/option_item.dart';
import 'package:equatable/equatable.dart';

enum DeliveryMethod { dineIn, takeAway }

class CheckoutPromotion extends Equatable {
  final String? selectedCoupon;
  final double couponDiscount;
  final int usedPoints;
  final double pointsDiscount;

  const CheckoutPromotion({
    this.selectedCoupon,
    this.couponDiscount = 0,
    this.usedPoints = 4500,
    this.pointsDiscount = 4000,
  });

  double get totalDiscount => couponDiscount + pointsDiscount;

  CheckoutPromotion copyWith({
    String? selectedCoupon,
    double? couponDiscount,
    int? usedPoints,
    double? pointsDiscount,
  }) {
    return CheckoutPromotion(
      selectedCoupon: selectedCoupon ?? this.selectedCoupon,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      usedPoints: usedPoints ?? this.usedPoints,
      pointsDiscount: pointsDiscount ?? this.pointsDiscount,
    );
  }

  @override
  List<Object?> get props => [selectedCoupon, couponDiscount, usedPoints, pointsDiscount];
}

class CheckoutPreferences extends Equatable {
  final String paymentMethodKey;
  final DeliveryMethod deliveryMethod;
  final String note;

  const CheckoutPreferences({
    this.paymentMethodKey = 'cash',
    this.deliveryMethod = DeliveryMethod.dineIn,
    this.note = '',
  });

  CheckoutPreferences copyWith({
    String? paymentMethodKey,
    DeliveryMethod? deliveryMethod,
    String? note,
  }) {
    return CheckoutPreferences(
      paymentMethodKey: paymentMethodKey ?? this.paymentMethodKey,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [paymentMethodKey, deliveryMethod, note];
}

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