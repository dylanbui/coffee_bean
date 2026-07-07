// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartListResponse _$CartListResponseFromJson(Map<String, dynamic> json) =>
    CartListResponse(
      validList:
          (json['validList'] as List<dynamic>?)
              ?.map((e) => CartItemResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      invalidList:
          (json['invalidList'] as List<dynamic>?)
              ?.map((e) => CartItemResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CartListResponseToJson(CartListResponse instance) =>
    <String, dynamic>{
      'validList': instance.validList,
      'invalidList': instance.invalidList,
    };

CartItemResponse _$CartItemResponseFromJson(Map<String, dynamic> json) =>
    CartItemResponse(
      id: (json['id'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      selected: json['selected'] as bool,
      spu: json['spu'] == null
          ? null
          : CartSpuResponse.fromJson(json['spu'] as Map<String, dynamic>),
      sku: json['sku'] == null
          ? null
          : CartSkuResponse.fromJson(json['sku'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CartItemResponseToJson(CartItemResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'count': instance.count,
      'selected': instance.selected,
      'spu': instance.spu,
      'sku': instance.sku,
    };

CartSpuResponse _$CartSpuResponseFromJson(Map<String, dynamic> json) =>
    CartSpuResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      picUrl: json['picUrl'] as String,
      categoryId: (json['categoryId'] as num).toInt(),
    );

Map<String, dynamic> _$CartSpuResponseToJson(CartSpuResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'picUrl': instance.picUrl,
      'categoryId': instance.categoryId,
    };

CartSkuResponse _$CartSkuResponseFromJson(Map<String, dynamic> json) =>
    CartSkuResponse(
      id: (json['id'] as num).toInt(),
      picUrl: json['picUrl'] as String?,
      price: (json['price'] as num).toInt(),
      properties: (json['properties'] as List<dynamic>?)
          ?.map(
            (e) => CartSkuPropertyResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$CartSkuResponseToJson(CartSkuResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'picUrl': instance.picUrl,
      'price': instance.price,
      'properties': instance.properties,
    };

CartSkuPropertyResponse _$CartSkuPropertyResponseFromJson(
  Map<String, dynamic> json,
) => CartSkuPropertyResponse(
  propertyId: (json['propertyId'] as num).toInt(),
  propertyName: json['propertyName'] as String,
  valueId: (json['valueId'] as num).toInt(),
  valueName: json['valueName'] as String,
);

Map<String, dynamic> _$CartSkuPropertyResponseToJson(
  CartSkuPropertyResponse instance,
) => <String, dynamic>{
  'propertyId': instance.propertyId,
  'propertyName': instance.propertyName,
  'valueId': instance.valueId,
  'valueName': instance.valueName,
};
