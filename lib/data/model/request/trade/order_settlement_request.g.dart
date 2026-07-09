// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_settlement_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSettlementRequest _$OrderSettlementRequestFromJson(
  Map<String, dynamic> json,
) => OrderSettlementRequest(
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItemRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  pointStatus: json['pointStatus'] as bool? ?? false,
  deliveryType: (json['deliveryType'] as num?)?.toInt() ?? 2,
  couponId: (json['couponId'] as num?)?.toInt(),
  addressId: (json['addressId'] as num?)?.toInt(),
  pickUpStoreId: (json['pickUpStoreId'] as num?)?.toInt(),
  receiverName: json['receiverName'] as String?,
  receiverMobile: json['receiverMobile'] as String?,
  seckillActivityId: (json['seckillActivityId'] as num?)?.toInt(),
  combinationActivityId: (json['combinationActivityId'] as num?)?.toInt(),
  combinationHeadId: (json['combinationHeadId'] as num?)?.toInt(),
  bargainRecordId: (json['bargainRecordId'] as num?)?.toInt(),
  pointActivityId: (json['pointActivityId'] as num?)?.toInt(),
);

Map<String, dynamic> _$OrderSettlementRequestToJson(
  OrderSettlementRequest instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'pointStatus': instance.pointStatus,
  'deliveryType': instance.deliveryType,
  'couponId': instance.couponId,
  'addressId': instance.addressId,
  'pickUpStoreId': instance.pickUpStoreId,
  'receiverName': instance.receiverName,
  'receiverMobile': instance.receiverMobile,
  'seckillActivityId': instance.seckillActivityId,
  'combinationActivityId': instance.combinationActivityId,
  'combinationHeadId': instance.combinationHeadId,
  'bargainRecordId': instance.bargainRecordId,
  'pointActivityId': instance.pointActivityId,
};

OrderItemRequest _$OrderItemRequestFromJson(Map<String, dynamic> json) =>
    OrderItemRequest(
      skuId: (json['skuId'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      cartId: (json['cartId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrderItemRequestToJson(OrderItemRequest instance) =>
    <String, dynamic>{
      'skuId': instance.skuId,
      'count': instance.count,
      'cartId': instance.cartId,
    };
