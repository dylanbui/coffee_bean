// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  introduction: json['introduction'] as String,
  categoryId: (json['categoryId'] as num).toInt(),
  picUrl: json['picUrl'] as String,
  sliderPicUrls: (json['sliderPicUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  specType: json['specType'] as bool,
  price: (json['price'] as num).toInt(),
  marketPrice: (json['marketPrice'] as num).toInt(),
  stock: (json['stock'] as num).toInt(),
  salesCount: (json['salesCount'] as num).toInt(),
  deliveryTypes: (json['deliveryTypes'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'introduction': instance.introduction,
  'categoryId': instance.categoryId,
  'picUrl': instance.picUrl,
  'sliderPicUrls': instance.sliderPicUrls,
  'specType': instance.specType,
  'price': instance.price,
  'marketPrice': instance.marketPrice,
  'stock': instance.stock,
  'salesCount': instance.salesCount,
  'deliveryTypes': instance.deliveryTypes,
};

ProductPageResult _$ProductPageResultFromJson(Map<String, dynamic> json) =>
    ProductPageResult(
      total: (json['total'] as num).toInt(),
      list: (json['list'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductPageResultToJson(ProductPageResult instance) =>
    <String, dynamic>{
      'total': instance.total,
      'list': instance.list.map((e) => e.toJson()).toList(),
    };

ProductDetail _$ProductDetailFromJson(Map<String, dynamic> json) =>
    ProductDetail(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      introduction: json['introduction'] as String,
      categoryId: (json['categoryId'] as num).toInt(),
      picUrl: json['picUrl'] as String,
      sliderPicUrls: (json['sliderPicUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      specType: json['specType'] as bool,
      price: (json['price'] as num).toInt(),
      marketPrice: (json['marketPrice'] as num).toInt(),
      stock: (json['stock'] as num).toInt(),
      salesCount: (json['salesCount'] as num).toInt(),
      deliveryTypes: (json['deliveryTypes'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      description: json['description'] as String,
      skus: (json['skus'] as List<dynamic>)
          .map((e) => Sku.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductDetailToJson(ProductDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'introduction': instance.introduction,
      'categoryId': instance.categoryId,
      'picUrl': instance.picUrl,
      'sliderPicUrls': instance.sliderPicUrls,
      'specType': instance.specType,
      'price': instance.price,
      'marketPrice': instance.marketPrice,
      'stock': instance.stock,
      'salesCount': instance.salesCount,
      'deliveryTypes': instance.deliveryTypes,
      'description': instance.description,
      'skus': instance.skus.map((e) => e.toJson()).toList(),
    };

Sku _$SkuFromJson(Map<String, dynamic> json) => Sku(
  id: (json['id'] as num).toInt(),
  properties: (json['properties'] as List<dynamic>)
      .map((e) => SkuProperty.fromJson(e as Map<String, dynamic>))
      .toList(),
  price: (json['price'] as num).toInt(),
  marketPrice: (json['marketPrice'] as num).toInt(),
  vipPrice: (json['vipPrice'] as num?)?.toInt(),
  picUrl: json['picUrl'] as String,
  stock: (json['stock'] as num).toInt(),
  weight: (json['weight'] as num?)?.toDouble(),
  volume: (json['volume'] as num?)?.toDouble(),
);

Map<String, dynamic> _$SkuToJson(Sku instance) => <String, dynamic>{
  'id': instance.id,
  'properties': instance.properties.map((e) => e.toJson()).toList(),
  'price': instance.price,
  'marketPrice': instance.marketPrice,
  'vipPrice': instance.vipPrice,
  'picUrl': instance.picUrl,
  'stock': instance.stock,
  'weight': instance.weight,
  'volume': instance.volume,
};

SkuProperty _$SkuPropertyFromJson(Map<String, dynamic> json) => SkuProperty(
  propertyId: (json['propertyId'] as num).toInt(),
  propertyName: json['propertyName'] as String,
  valueId: (json['valueId'] as num).toInt(),
  valueName: json['valueName'] as String,
);

Map<String, dynamic> _$SkuPropertyToJson(SkuProperty instance) =>
    <String, dynamic>{
      'propertyId': instance.propertyId,
      'propertyName': instance.propertyName,
      'valueId': instance.valueId,
      'valueName': instance.valueName,
    };
