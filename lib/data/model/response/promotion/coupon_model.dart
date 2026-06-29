import 'package:coffee_bean/data/local/settings_app_manager/settings_app_manager.dart';
import 'package:coffee_bean/utils/language_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coupon_model.g.dart';

@JsonSerializable()
class CouponModel extends Equatable {
  final int id;
  final String name;
  final int status;
  final int usePrice;
  final int productScope;
  final List<int>? productScopeValues;
  final int? validStartTime; // UTC timestamp in milliseconds
  final int? validEndTime;   // UTC timestamp in milliseconds
  final int discountType; // 1: Cash (Tiền mặt), 2: Percent/Discount (Chiết khấu)
  final int? discountPercent;
  final int? discountPrice;
  final int? discountLimitPrice;
  
  // Custom field requested by user
  final String? description;

  // UI States (not from API)
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isSelected;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isExpanded;

  const CouponModel({
    required this.id,
    required this.name,
    required this.status,
    required this.usePrice,
    required this.productScope,
    this.productScopeValues,
    this.validStartTime,
    this.validEndTime,
    required this.discountType,
    this.discountPercent,
    this.discountPrice,
    this.discountLimitPrice,
    this.description,
    this.isSelected = false,
    this.isExpanded = false,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) => _$CouponModelFromJson(json);

  Map<String, dynamic> toJson() => _$CouponModelToJson(this);

  // --- Compatibility & Helper Getters ---

  String get title => name;

  /// Convert UTC timestamp (ms) to local DateTime (Standard Rule 8)
  DateTime? get startDateTime => validStartTime != null ? DateTime.fromMillisecondsSinceEpoch(validStartTime!).toLocal() : null;
  DateTime? get endDateTime => validEndTime != null ? DateTime.fromMillisecondsSinceEpoch(validEndTime!).toLocal() : null;

  String get displayValue {
    final currency = SettingsAppManager.currentCurrency;
    final lang = SettingsAppManager.currentLanguage;

    if (discountType == 1) { // Cash
      final double amount = (discountPrice ?? 0) / currency.divisor;
      return amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : currency.decimalDigits);
    } else if (discountType == 2) { // Percent
      if (lang == Language.cn) {
        // China: 85 means 8.5折
        return ((discountPercent ?? 0) / 10).toStringAsFixed(1);
      }
      // VI/EN: 85 means 85%
      return (discountPercent ?? 0).toString();
    }
    return "0";
  }

  double get discountValue {
    if (discountType == 1) return (discountPrice ?? 0) / 100.0;
    if (discountType == 2) return (discountPercent ?? 0).toDouble(); // Return percent value (e.g. 85.0 for 85%)
    return 0.0;
  }

  String get discountTypeUnit {
    if (discountType == 1) return SettingsAppManager.currentCurrency.symbol;
    return SettingsAppManager.currentLanguage.discountUnit;
  }

  /// Phục vụ cho logic checkout cũ sử dụng "%"
  String get discountTypeStr {
    if (discountType == 1) return SettingsAppManager.currentCurrency.symbol;
    return "%";
  }

  String get thresholdText {
    final lang = SettingsAppManager.currentLanguage;
    final formattedPrice = SettingsAppManager.currentCurrency.format(usePrice);
    
    if (lang == Language.cn) {
      return "${lang.minSpendLabel}$formattedPrice可用";
    }
    return "${lang.minSpendLabel} $formattedPrice";
  }

  // --- Utility ---

  CouponModel copyWith({
    bool? isSelected,
    bool? isExpanded,
  }) {
    return CouponModel(
      id: id,
      name: name,
      status: status,
      usePrice: usePrice,
      productScope: productScope,
      productScopeValues: productScopeValues,
      validStartTime: validStartTime,
      validEndTime: validEndTime,
      discountType: discountType,
      discountPercent: discountPercent,
      discountPrice: discountPrice,
      discountLimitPrice: discountLimitPrice,
      description: description,
      isSelected: isSelected ?? this.isSelected,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        status,
        usePrice,
        productScope,
        productScopeValues,
        validStartTime,
        validEndTime,
        discountType,
        discountPercent,
        discountPrice,
        discountLimitPrice,
        description,
        isSelected,
        isExpanded,
      ];
}
