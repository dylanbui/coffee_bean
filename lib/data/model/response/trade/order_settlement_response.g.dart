// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_settlement_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSettlementResponse _$OrderSettlementResponseFromJson(
  Map<String, dynamic> json,
) => OrderSettlementResponse(
  type: (json['type'] as num?)?.toInt(),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => SettlementItemResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  coupons: (json['coupons'] as List<dynamic>?)
      ?.map((e) => SettlementCouponResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  price: json['price'] == null
      ? null
      : SettlementPriceResponse.fromJson(json['price'] as Map<String, dynamic>),
  address: json['address'] == null
      ? null
      : SettlementAddressResponse.fromJson(
          json['address'] as Map<String, dynamic>,
        ),
  usePoint: (json['usePoint'] as num?)?.toInt(),
  totalPoint: (json['totalPoint'] as num?)?.toInt(),
  promotions: (json['promotions'] as List<dynamic>?)
      ?.map(
        (e) => SettlementPromotionResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$OrderSettlementResponseToJson(
  OrderSettlementResponse instance,
) => <String, dynamic>{
  'type': instance.type,
  'items': instance.items,
  'coupons': instance.coupons,
  'price': instance.price,
  'address': instance.address,
  'usePoint': instance.usePoint,
  'totalPoint': instance.totalPoint,
  'promotions': instance.promotions,
};

SettlementItemResponse _$SettlementItemResponseFromJson(
  Map<String, dynamic> json,
) => SettlementItemResponse(
  skuId: (json['skuId'] as num).toInt(),
  count: (json['count'] as num).toInt(),
  cartId: (json['cartId'] as num?)?.toInt(),
  name: json['name'] as String?,
  picUrl: json['picUrl'] as String?,
  price: (json['price'] as num?)?.toInt(),
);

Map<String, dynamic> _$SettlementItemResponseToJson(
  SettlementItemResponse instance,
) => <String, dynamic>{
  'skuId': instance.skuId,
  'count': instance.count,
  'cartId': instance.cartId,
  'name': instance.name,
  'picUrl': instance.picUrl,
  'price': instance.price,
};

SettlementCouponResponse _$SettlementCouponResponseFromJson(
  Map<String, dynamic> json,
) => SettlementCouponResponse(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  usePrice: (json['usePrice'] as num?)?.toInt(),
  discountPrice: (json['discountPrice'] as num?)?.toInt(),
  match: json['match'] as bool? ?? false,
  mismatchReason: json['mismatchReason'] as String?,
);

Map<String, dynamic> _$SettlementCouponResponseToJson(
  SettlementCouponResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'usePrice': instance.usePrice,
  'discountPrice': instance.discountPrice,
  'match': instance.match,
  'mismatchReason': instance.mismatchReason,
};

SettlementPriceResponse _$SettlementPriceResponseFromJson(
  Map<String, dynamic> json,
) => SettlementPriceResponse(
  totalPrice: (json['totalPrice'] as num?)?.toInt() ?? 0,
  discountPrice: (json['discountPrice'] as num?)?.toInt() ?? 0,
  deliveryPrice: (json['deliveryPrice'] as num?)?.toInt() ?? 0,
  couponPrice: (json['couponPrice'] as num?)?.toInt() ?? 0,
  pointPrice: (json['pointPrice'] as num?)?.toInt() ?? 0,
  payPrice: (json['payPrice'] as num?)?.toInt() ?? 0,
  vipPrice: (json['vipPrice'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SettlementPriceResponseToJson(
  SettlementPriceResponse instance,
) => <String, dynamic>{
  'totalPrice': instance.totalPrice,
  'discountPrice': instance.discountPrice,
  'deliveryPrice': instance.deliveryPrice,
  'couponPrice': instance.couponPrice,
  'pointPrice': instance.pointPrice,
  'payPrice': instance.payPrice,
  'vipPrice': instance.vipPrice,
};

SettlementAddressResponse _$SettlementAddressResponseFromJson(
  Map<String, dynamic> json,
) => SettlementAddressResponse(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  mobile: json['mobile'] as String?,
  areaId: (json['areaId'] as num?)?.toInt(),
  areaName: json['areaName'] as String?,
  detailAddress: json['detailAddress'] as String?,
  defaultStatus: json['defaultStatus'] as bool?,
);

Map<String, dynamic> _$SettlementAddressResponseToJson(
  SettlementAddressResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'mobile': instance.mobile,
  'areaId': instance.areaId,
  'areaName': instance.areaName,
  'detailAddress': instance.detailAddress,
  'defaultStatus': instance.defaultStatus,
};

SettlementPromotionResponse _$SettlementPromotionResponseFromJson(
  Map<String, dynamic> json,
) => SettlementPromotionResponse(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  type: (json['type'] as num).toInt(),
  totalPrice: (json['totalPrice'] as num).toInt(),
  discountPrice: (json['discountPrice'] as num).toInt(),
  items: (json['items'] as List<dynamic>?)
      ?.map(
        (e) =>
            SettlementPromotionItemResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  match: json['match'] as bool? ?? false,
  description: json['description'] as String?,
);

Map<String, dynamic> _$SettlementPromotionResponseToJson(
  SettlementPromotionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'totalPrice': instance.totalPrice,
  'discountPrice': instance.discountPrice,
  'items': instance.items,
  'match': instance.match,
  'description': instance.description,
};

SettlementPromotionItemResponse _$SettlementPromotionItemResponseFromJson(
  Map<String, dynamic> json,
) => SettlementPromotionItemResponse(
  skuId: (json['skuId'] as num).toInt(),
  totalPrice: (json['totalPrice'] as num).toInt(),
  discountPrice: (json['discountPrice'] as num).toInt(),
);

Map<String, dynamic> _$SettlementPromotionItemResponseToJson(
  SettlementPromotionItemResponse instance,
) => <String, dynamic>{
  'skuId': instance.skuId,
  'totalPrice': instance.totalPrice,
  'discountPrice': instance.discountPrice,
};
