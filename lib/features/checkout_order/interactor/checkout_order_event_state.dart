import 'package:coffee_bean/data/model/payment_domain.dart';
import 'package:coffee_bean/data/model/response/trade/order_settlement_response.dart';
import 'package:coffee_bean/features/checkout_order/checkout_order_common.dart';
import 'package:db_core/db_core.dart';

enum CheckoutOrderStatus { confirming, processing, success, failure }

class UIStatus extends Equatable {
  final bool isLoading;
  final String processingMessage;
  final String? successMessageKey;
  final String? errorMessage;

  const UIStatus({
    this.isLoading = true,
    this.processingMessage = '',
    this.successMessageKey,
    this.errorMessage,
  });

  UIStatus copyWith({
    bool? isLoading,
    String? processingMessage,
    String? successMessageKey,
    String? errorMessage,
  }) {
    return UIStatus(
      isLoading: isLoading ?? this.isLoading,
      processingMessage: processingMessage ?? this.processingMessage,
      successMessageKey: successMessageKey ?? this.successMessageKey,
      errorMessage: errorMessage, // Allow setting to null
    );
  }

  @override
  List<Object?> get props => [isLoading, processingMessage, successMessageKey, errorMessage];
}

class CheckoutOrderState extends BaseBlocState {
  final CheckoutOrderStatus status;
  final String? orderNumber;
  final CheckoutItemContract? checkoutItem;

  final UIStatus uiStatus;
  final CheckoutPromotion promotion;
  final CheckoutPreferences preferences;

  final OrderSettlementResponse? settlement;

  // Dữ liệu điểm tích lũy
  final double userPoints;
  final double usedPoints;
  final double pointConversionRate; 

  final double optionsAmount;
  final bool isOrderButtonEnabled;

  CheckoutOrderState({
    this.status = CheckoutOrderStatus.confirming,
    this.orderNumber,
    this.checkoutItem,
    this.uiStatus = const UIStatus(),
    this.promotion = const CheckoutPromotion(),
    this.preferences = const CheckoutPreferences(),
    this.settlement,
    this.userPoints = 0,
    this.usedPoints = 0,
    this.pointConversionRate = 1000,
    this.optionsAmount = 0,
    this.isOrderButtonEnabled = true,
  });

  // Getters & Logic (Server-driven priority)
  double get baseAmount => checkoutItem?.baseAmount ?? 0;

  double get potentialPointDiscount {
    // Nếu đã có kết quả từ Server và đang dùng điểm, lấy trực tiếp từ Server
    if (settlement != null && (settlement?.usePoint ?? 0) > 0) {
      return (settlement?.price?.pointPrice ?? 0).toDouble();
    }
    // Nếu chưa dùng hoặc chưa có API, tính tạm ở Client để hiển thị "Preview"
    final maxPointsNeeded = (baseAmount + optionsAmount) / pointConversionRate;
    final pointsToUse = userPoints > maxPointsNeeded ? maxPointsNeeded : userPoints;
    return pointsToUse * pointConversionRate;
  }

  double get deliveryPrice => (settlement?.price?.deliveryPrice ?? 0).toDouble();
  double get couponDiscount => (settlement?.price?.couponPrice ?? 0).toDouble();
  double get pointDiscount => (settlement?.price?.pointPrice ?? 0).toDouble();
  double get totalDiscount => (settlement?.price?.discountPrice ?? 0).toDouble();
  double get payPrice => (settlement?.price?.payPrice ?? 0).toDouble();

  double get finalAmount => settlement != null ? payPrice : (baseAmount + optionsAmount - (promotion.couponDiscount + usedPoints * pointConversionRate)).clamp(0, double.infinity);

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
    OrderSettlementResponse? settlement,
    double? userPoints,
    double? usedPoints,
    double? pointConversionRate,
    double? optionsAmount,
    bool? isOrderButtonEnabled,
  }) {
    return CheckoutOrderState(
      status: status ?? this.status,
      orderNumber: orderNumber ?? this.orderNumber,
      checkoutItem: checkoutItem ?? this.checkoutItem,
      uiStatus: uiStatus ?? this.uiStatus,
      promotion: promotion ?? this.promotion,
      preferences: preferences ?? this.preferences,
      settlement: settlement ?? this.settlement,
      userPoints: userPoints ?? this.userPoints,
      usedPoints: usedPoints ?? this.usedPoints,
      pointConversionRate: pointConversionRate ?? this.pointConversionRate,
      optionsAmount: optionsAmount ?? this.optionsAmount,
      isOrderButtonEnabled: isOrderButtonEnabled ?? this.isOrderButtonEnabled,
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
        settlement,
        userPoints,
        usedPoints,
        pointConversionRate,
        optionsAmount,
        isOrderButtonEnabled,
      ];
}
