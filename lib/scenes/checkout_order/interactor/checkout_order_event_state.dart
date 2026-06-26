import 'package:coffee_bean/data/model/payment_domain.dart';
import 'package:coffee_bean/scenes/checkout_order/checkout_order_common.dart';
import 'package:db_core/db_core.dart';

enum CheckoutOrderStatus { confirming, processing, success, failure }

class UIStatus extends Equatable {
  final bool isLoading;
  final String processingMessage;
  final String? successMessageKey;

  const UIStatus({
    this.isLoading = true,
    this.processingMessage = '',
    this.successMessageKey,
  });

  UIStatus copyWith({
    bool? isLoading,
    String? processingMessage,
    String? successMessageKey,
  }) {
    return UIStatus(
      isLoading: isLoading ?? this.isLoading,
      processingMessage: processingMessage ?? this.processingMessage,
      successMessageKey: successMessageKey ?? this.successMessageKey,
    );
  }

  @override
  List<Object?> get props => [isLoading, processingMessage, successMessageKey];
}

class CheckoutOrderState extends BaseBlocState {
  final CheckoutOrderStatus status;
  final String? orderNumber;
  final CheckoutItemContract? checkoutItem;

  final UIStatus uiStatus;
  final CheckoutPromotion promotion;
  final CheckoutPreferences preferences;

  // Dữ liệu điểm tích lũy
  final double userPoints;
  final double usedPoints;
  final double pointConversionRate; 

  CheckoutOrderState({
    this.status = CheckoutOrderStatus.confirming,
    this.orderNumber,
    this.checkoutItem,
    this.uiStatus = const UIStatus(),
    this.promotion = const CheckoutPromotion(),
    this.preferences = const CheckoutPreferences(),
    this.userPoints = 0,
    this.usedPoints = 0,
    this.pointConversionRate = 1000, 
  });

  // Getters & Logic (Clone từ order_confirmation nhưng dùng baseAmount)
  double get baseAmount => checkoutItem?.baseAmount ?? 0;
  
  double get potentialPointDiscount {
    final maxPointsNeeded = baseAmount / pointConversionRate;
    final pointsToUse = userPoints > maxPointsNeeded ? maxPointsNeeded : userPoints;
    return pointsToUse * pointConversionRate;
  }

  double get pointDiscount => usedPoints * pointConversionRate;
  double get totalDiscount => promotion.couponDiscount + pointDiscount;
  double get finalAmount => (baseAmount - totalDiscount).clamp(0, double.infinity);

  bool get isLoading => uiStatus.isLoading;
  String get processingMessage => uiStatus.processingMessage;
  String? get successMessageKey => uiStatus.successMessageKey;

  CheckoutOrderState copyWith({
    CheckoutOrderStatus? status,
    String? orderNumber,
    CheckoutItemContract? checkoutItem,
    UIStatus? uiStatus,
    CheckoutPromotion? promotion,
    CheckoutPreferences? preferences,
    double? userPoints,
    double? usedPoints,
    double? pointConversionRate,
  }) {
    return CheckoutOrderState(
      status: status ?? this.status,
      orderNumber: orderNumber ?? this.orderNumber,
      checkoutItem: checkoutItem ?? this.checkoutItem,
      uiStatus: uiStatus ?? this.uiStatus,
      promotion: promotion ?? this.promotion,
      preferences: preferences ?? this.preferences,
      userPoints: userPoints ?? this.userPoints,
      usedPoints: usedPoints ?? this.usedPoints,
      pointConversionRate: pointConversionRate ?? this.pointConversionRate,
    );
  }

  @override
  List<Object?> get props => [
        status,
        orderNumber,
        checkoutItem,
        uiStatus,
        promotion,
        preferences,
        userPoints,
        usedPoints,
        pointConversionRate,
      ];
}
