import 'package:coffee_bean/data/model/payment_domain.dart';
// import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_event_state.dart';
import 'package:coffee_bean/scenes/order_confirmation/interactor/order_confirmation_event_state.dart';
import 'package:db_core/db_core.dart';

enum VenuePaymentStatus { confirming, processing, success, failure }

class VenuePaymentParams extends Equatable {
  final String venueName;
  final String imageUrl;
  final String address;
  final String openingHours;
  final List<dynamic> selectedSlots;
  final List<dynamic> courts;

  const VenuePaymentParams({
    required this.venueName,
    required this.imageUrl,
    required this.address,
    required this.openingHours,
    required this.selectedSlots,
    required this.courts,
  });

  @override
  List<Object?> get props => [venueName, imageUrl, address, openingHours, selectedSlots, courts];
}

class VenuePaymentState extends BaseBlocState {
  final VenuePaymentStatus status;
  final VenuePaymentParams params;
  final UIStatus uiStatus;
  final CheckoutPromotion promotion;
  final CheckoutPreferences preferences;

  VenuePaymentState({
    this.status = VenuePaymentStatus.confirming,
    required this.params,
    this.uiStatus = const UIStatus(),
    this.promotion = const CheckoutPromotion(),
    this.preferences = const CheckoutPreferences(),
  });

  double get subtotal => 0.0; // Temporarily commented out: params.selectedSlots.fold(0, (sum, slot) => sum + slot.price);
  double get totalAmount => subtotal - promotion.totalDiscount;

  VenuePaymentState copyWith({
    VenuePaymentStatus? status,
    VenuePaymentParams? params,
    UIStatus? uiStatus,
    CheckoutPromotion? promotion,
    CheckoutPreferences? preferences,
  }) {
    return VenuePaymentState(
      status: status ?? this.status,
      params: params ?? this.params,
      uiStatus: uiStatus ?? this.uiStatus,
      promotion: promotion ?? this.promotion,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [status, params, uiStatus, promotion, preferences];
}
