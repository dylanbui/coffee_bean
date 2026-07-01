import 'package:json_annotation/json_annotation.dart';
import 'package:db_core/commons_constants.dart';

part 'cart_list_response.g.dart';

@JsonSerializable()
class CartListResponse {
  final List<CartItemResponse> validList;
  final List<CartItemResponse> invalidList;

  CartListResponse({
    this.validList = const [],
    this.invalidList = const [],
  });

  factory CartListResponse.fromJson(Dictionary json) => _$CartListResponseFromJson(json);
  Dictionary toJson() => _$CartListResponseToJson(this);
}

@JsonSerializable()
class CartItemResponse {
  final int id;
  final int count;
  final bool selected;
  final CartSpuResponse? spu;
  final CartSkuResponse? sku;

  CartItemResponse({
    required this.id,
    required this.count,
    required this.selected,
    this.spu,
    this.sku,
  });

  factory CartItemResponse.fromJson(Dictionary json) => _$CartItemResponseFromJson(json);
  Dictionary toJson() => _$CartItemResponseToJson(this);
}

@JsonSerializable()
class CartSpuResponse {
  final int id;
  final String name;
  final String picUrl;
  final int categoryId;

  CartSpuResponse({
    required this.id,
    required this.name,
    required this.picUrl,
    required this.categoryId,
  });

  factory CartSpuResponse.fromJson(Dictionary json) => _$CartSpuResponseFromJson(json);
  Dictionary toJson() => _$CartSpuResponseToJson(this);
}

@JsonSerializable()
class CartSkuResponse {
  final int id;
  final String? picUrl;
  final int price;
  final List<CartSkuPropertyResponse>? properties;

  CartSkuResponse({
    required this.id,
    this.picUrl,
    required this.price,
    this.properties,
  });

  factory CartSkuResponse.fromJson(Dictionary json) => _$CartSkuResponseFromJson(json);
  Dictionary toJson() => _$CartSkuResponseToJson(this);
}

@JsonSerializable()
class CartSkuPropertyResponse {
  final int propertyId;
  final String propertyName;
  final int valueId;
  final String valueName;

  CartSkuPropertyResponse({
    required this.propertyId,
    required this.propertyName,
    required this.valueId,
    required this.valueName,
  });

  factory CartSkuPropertyResponse.fromJson(Dictionary json) => _$CartSkuPropertyResponseFromJson(json);
  Dictionary toJson() => _$CartSkuPropertyResponseToJson(this);
}
