import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:equatable/equatable.dart';

enum DeliveryMethod { dineIn, takeAway }

enum OrderConfirmationStatus { confirming, processing, success, failure }

// --- SUB-MODELS ---

class UIStatus extends Equatable {
  final bool isLoading;
  final String processingMessage;
  final String? successMessageKey; // Sử dụng Key để hỗ trợ đa ngôn ngữ sau này

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

class OrderPromotion extends Equatable {
  final String? selectedCoupon;
  final double couponDiscount;
  final int usedPoints;
  final double pointsDiscount;

  const OrderPromotion({
    this.selectedCoupon,
    this.couponDiscount = 0,
    this.usedPoints = 4500,
    this.pointsDiscount = 4000,
  });

  double get totalDiscount => couponDiscount + pointsDiscount;

  OrderPromotion copyWith({
    String? selectedCoupon,
    double? couponDiscount,
    int? usedPoints,
    double? pointsDiscount,
  }) {
    return OrderPromotion(
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

// --- MAIN STATE ---

class OrderConfirmationState extends BaseBlocState {
  final OrderConfirmationStatus status;
  final String? orderNumber;
  final TblStore? selectedStore;
  final List<TblCartItem> cartItems;

  final UIStatus uiStatus;
  final OrderPromotion promotion;
  final CheckoutPreferences preferences;

  OrderConfirmationState({
    this.status = OrderConfirmationStatus.confirming,
    this.orderNumber,
    this.selectedStore,
    this.cartItems = const [],
    this.uiStatus = const UIStatus(),
    this.promotion = const OrderPromotion(),
    this.preferences = const CheckoutPreferences(),
  });

  // Getters & Logic
  double get subtotal => cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  double get totalAmount => subtotal - promotion.totalDiscount;

  // Shortcuts cho UI
  bool get isLoading => uiStatus.isLoading;
  String get processingMessage => uiStatus.processingMessage;
  String? get successMessageKey => uiStatus.successMessageKey;

  OrderConfirmationState copyWith({
    OrderConfirmationStatus? status,
    String? orderNumber,
    TblStore? selectedStore,
    List<TblCartItem>? cartItems,
    UIStatus? uiStatus,
    OrderPromotion? promotion,
    CheckoutPreferences? preferences,
  }) {
    return OrderConfirmationState(
      status: status ?? this.status,
      orderNumber: orderNumber ?? this.orderNumber,
      selectedStore: selectedStore ?? this.selectedStore,
      cartItems: cartItems ?? this.cartItems,
      uiStatus: uiStatus ?? this.uiStatus,
      promotion: promotion ?? this.promotion,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [
        status,
        orderNumber,
        selectedStore,
        cartItems,
        uiStatus,
        promotion,
        preferences,
      ];
}
