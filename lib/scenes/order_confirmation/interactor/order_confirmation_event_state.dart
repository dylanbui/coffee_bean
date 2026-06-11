import 'package:coffee_bean/data/model/payment_domain.dart';
import 'package:db_core/db_core.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';

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

// --- MAIN STATE ---

class OrderConfirmationState extends BaseBlocState {
  final OrderConfirmationStatus status;
  final String? orderNumber;
  final TblStore? selectedStore;
  final List<TblCartItem> cartItems;

  final UIStatus uiStatus;
  final CheckoutPromotion promotion;
  final CheckoutPreferences preferences;

  OrderConfirmationState({
    this.status = OrderConfirmationStatus.confirming,
    this.orderNumber,
    this.selectedStore,
    this.cartItems = const [],
    this.uiStatus = const UIStatus(),
    this.promotion = const CheckoutPromotion(),
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
    CheckoutPromotion? promotion,
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
