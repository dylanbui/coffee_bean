import 'package:json_annotation/json_annotation.dart';
import 'package:db_core/commons_constants.dart';

part 'order_settlement_response.g.dart';

@JsonSerializable()
class OrderSettlementResponse {
  final int? type;
  final List<SettlementItemResponse>? items;
  final List<SettlementCouponResponse>? coupons;
  final SettlementPriceResponse? price;
  final SettlementAddressResponse? address;
  final int? usePoint;
  final int? totalPoint;
  final List<SettlementPromotionResponse>? promotions;

  OrderSettlementResponse({this.type, this.items, this.coupons, this.price, this.address, this.usePoint, this.totalPoint, this.promotions});

  factory OrderSettlementResponse.fromJson(Dictionary json) => _$OrderSettlementResponseFromJson(json);
  Dictionary toJson() => _$OrderSettlementResponseToJson(this);
}

@JsonSerializable()
class SettlementItemResponse {
  final int skuId;
  final int count;
  final int? cartId;
  final String? name;
  final String? picUrl;
  final int? price;

  SettlementItemResponse({required this.skuId, required this.count, this.cartId, this.name, this.picUrl, this.price});

  factory SettlementItemResponse.fromJson(Dictionary json) => _$SettlementItemResponseFromJson(json);
  Dictionary toJson() => _$SettlementItemResponseToJson(this);
}

@JsonSerializable()
class SettlementCouponResponse {
  final int id;
  final String name;
  final int? usePrice;
  final int? discountPrice;
  final bool match;
  final String? mismatchReason;

  SettlementCouponResponse({required this.id, required this.name, this.usePrice, this.discountPrice, this.match = false, this.mismatchReason});

  factory SettlementCouponResponse.fromJson(Dictionary json) => _$SettlementCouponResponseFromJson(json);
  Dictionary toJson() => _$SettlementCouponResponseToJson(this);
}

@JsonSerializable()
class SettlementPriceResponse {
  final int totalPrice;
  final int discountPrice;
  final int deliveryPrice;
  final int couponPrice;
  final int pointPrice;
  final int payPrice;
  final int vipPrice;

  SettlementPriceResponse({
    this.totalPrice = 0, 
    this.discountPrice = 0, 
    this.deliveryPrice = 0, 
    this.couponPrice = 0, 
    this.pointPrice = 0, 
    this.payPrice = 0,
    this.vipPrice = 0,
  });

  factory SettlementPriceResponse.fromJson(Dictionary json) => _$SettlementPriceResponseFromJson(json);
  Dictionary toJson() => _$SettlementPriceResponseToJson(this);
}

@JsonSerializable()
class SettlementAddressResponse {
  final int? id;
  final String? name;
  final String? mobile;
  final int? areaId;
  final String? areaName;
  final String? detailAddress;
  final bool? defaultStatus;

  SettlementAddressResponse({this.id, this.name, this.mobile, this.areaId, this.areaName, this.detailAddress, this.defaultStatus});

  factory SettlementAddressResponse.fromJson(Dictionary json) => _$SettlementAddressResponseFromJson(json);
  Dictionary toJson() => _$SettlementAddressResponseToJson(this);
}

@JsonSerializable()
class SettlementPromotionResponse {
  final int id;
  final String name;
  final int type;
  final int totalPrice;
  final int discountPrice;
  final List<SettlementPromotionItemResponse>? items;
  final bool match;
  final String? description;

  SettlementPromotionResponse({required this.id, required this.name, required this.type, required this.totalPrice, required this.discountPrice, this.items, this.match = false, this.description});

  factory SettlementPromotionResponse.fromJson(Dictionary json) => _$SettlementPromotionResponseFromJson(json);
  Dictionary toJson() => _$SettlementPromotionResponseToJson(this);
}

@JsonSerializable()
class SettlementPromotionItemResponse {
  final int skuId;
  final int totalPrice;
  final int discountPrice;

  SettlementPromotionItemResponse({required this.skuId, required this.totalPrice, required this.discountPrice});

  factory SettlementPromotionItemResponse.fromJson(Dictionary json) => _$SettlementPromotionItemResponseFromJson(json);
  Dictionary toJson() => _$SettlementPromotionItemResponseToJson(this);
}
