// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponModel _$CouponModelFromJson(Map<String, dynamic> json) => CouponModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  status: (json['status'] as num).toInt(),
  usePrice: (json['usePrice'] as num).toInt(),
  productScope: (json['productScope'] as num).toInt(),
  productScopeValues: (json['productScopeValues'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  validStartTime: (json['validStartTime'] as num?)?.toInt(),
  validEndTime: (json['validEndTime'] as num?)?.toInt(),
  discountType: (json['discountType'] as num).toInt(),
  discountPercent: (json['discountPercent'] as num?)?.toInt(),
  discountPrice: (json['discountPrice'] as num?)?.toInt(),
  discountLimitPrice: (json['discountLimitPrice'] as num?)?.toInt(),
  description: json['description'] as String?,
);

Map<String, dynamic> _$CouponModelToJson(CouponModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'usePrice': instance.usePrice,
      'productScope': instance.productScope,
      'productScopeValues': instance.productScopeValues,
      'validStartTime': instance.validStartTime,
      'validEndTime': instance.validEndTime,
      'discountType': instance.discountType,
      'discountPercent': instance.discountPercent,
      'discountPrice': instance.discountPrice,
      'discountLimitPrice': instance.discountLimitPrice,
      'description': instance.description,
    };
