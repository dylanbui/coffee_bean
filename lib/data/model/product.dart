import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:coffee_bean/data/local/app_setting_manager/app_setting_manager.dart';
import 'package:coffee_bean/utils/currency_utils.dart';

part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product extends Equatable {
  final int id;
// ... (giữ nguyên các field cũ)
  final String name;
  final String introduction;
  final int categoryId;
  final String picUrl;
  final List<String> sliderPicUrls;
  final bool specType;
  final int price;
  final int marketPrice;
  final int stock;
  final int salesCount;
  final List<int> deliveryTypes;

  const Product({
    required this.id,
    required this.name,
    required this.introduction,
    required this.categoryId,
    required this.picUrl,
    required this.sliderPicUrls,
    required this.specType,
    required this.price,
    required this.marketPrice,
    required this.stock,
    required this.salesCount,
    required this.deliveryTypes,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        introduction,
        categoryId,
        picUrl,
        sliderPicUrls,
        specType,
        price,
        marketPrice,
        stock,
        salesCount,
        deliveryTypes,
      ];
}

@JsonSerializable(explicitToJson: true)
class ProductPageResult {
  final int total;
  final List<Product> list;

  ProductPageResult({required this.total, required this.list});

  factory ProductPageResult.fromJson(Map<String, dynamic> json) => _$ProductPageResultFromJson(json);

  Map<String, dynamic> toJson() => _$ProductPageResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProductDetail extends Product {
  final String description;
  final List<Sku> skus;

  const ProductDetail({
    required super.id,
    required super.name,
    required super.introduction,
    required super.categoryId,
    required super.picUrl,
    required super.sliderPicUrls,
    required super.specType,
    required super.price,
    required super.marketPrice,
    required super.stock,
    required super.salesCount,
    required super.deliveryTypes,
    required this.description,
    required this.skus,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => _$ProductDetailFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProductDetailToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Sku {
  final int id;
  final List<SkuProperty> properties;
  final int price;
  final int marketPrice;
  final int vipPrice;
  final String picUrl;
  final int stock;
  final double weight;
  final double volume;

  Sku({
    required this.id,
    required this.properties,
    required this.price,
    required this.marketPrice,
    required this.vipPrice,
    required this.picUrl,
    required this.stock,
    required this.weight,
    required this.volume,
  });

  factory Sku.fromJson(Map<String, dynamic> json) => _$SkuFromJson(json);

  Map<String, dynamic> toJson() => _$SkuToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SkuProperty {
  final int propertyId;
  final String propertyName;
  final int valueId;
  final String valueName;

  SkuProperty({
    required this.propertyId,
    required this.propertyName,
    required this.valueId,
    required this.valueName,
  });

  factory SkuProperty.fromJson(Map<String, dynamic> json) => _$SkuPropertyFromJson(json);

  Map<String, dynamic> toJson() => _$SkuPropertyToJson(this);
}

extension ProductDisplayExtension on Product {
  String formattedPrice({Currency? currency}) {
    // Nếu không truyền tham số, tự động lấy cấu hình Global từ AppSettingManager
    final targetCurrency = currency ?? AppSettingManager.currentCurrency;
    return targetCurrency.format(price);
  }

  String formattedMarketPrice({Currency? currency}) {
    final targetCurrency = currency ?? AppSettingManager.currentCurrency;
    return targetCurrency.format(marketPrice);
  }
}
