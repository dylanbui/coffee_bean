// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreModel _$StoreModelFromJson(Map<String, dynamic> json) => StoreModel(
  id: (json['id'] as num).toInt(),
  brandId: (json['brandId'] as num?)?.toInt(),
  merchantId: (json['merchantId'] as num?)?.toInt(),
  name: json['name'] as String,
  logo: json['logo'] as String?,
  phone: json['phone'] as String?,
  areaId: (json['areaId'] as num?)?.toInt(),
  areaName: json['areaName'] as String?,
  detailAddress: json['detailAddress'] as String?,
  openingTime: json['openingTime'] as String?,
  closingTime: json['closingTime'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
  longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
  distance: (json['distance'] as num?)?.toDouble(),
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$StoreModelToJson(StoreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brandId': instance.brandId,
      'merchantId': instance.merchantId,
      'name': instance.name,
      'logo': instance.logo,
      'phone': instance.phone,
      'areaId': instance.areaId,
      'areaName': instance.areaName,
      'detailAddress': instance.detailAddress,
      'openingTime': instance.openingTime,
      'closingTime': instance.closingTime,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'distance': instance.distance,
      'images': instance.images,
    };
