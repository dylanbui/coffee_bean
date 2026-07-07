import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'store_model.g.dart';

@JsonSerializable()
class StoreModel extends Equatable {
  final int id;
  final int? brandId;
  final int? merchantId;
  final String name;
  final String? logo;
  final String? phone;
  final int? areaId;
  final String? areaName;
  final String? detailAddress;
  final String? openingTime;
  final String? closingTime;
  final double latitude;
  final double longitude;
  final double? distance;
  final List<String>? images;

  const StoreModel({
    required this.id,
    this.brandId,
    this.merchantId,
    required this.name,
    this.logo,
    this.phone,
    this.areaId,
    this.areaName,
    this.detailAddress,
    this.openingTime,
    this.closingTime,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.distance,
    this.images,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => _$StoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoreModelToJson(this);

  String? get mainImage {
    if (logo != null && logo!.isNotEmpty) return logo;
    if (images != null && images!.isNotEmpty) return images!.first;
    return null;
  }

  String get fullAddress => detailAddress ?? "";

  @override
  List<Object?> get props => [
        id,
        brandId,
        merchantId,
        name,
        logo,
        phone,
        areaId,
        areaName,
        detailAddress,
        openingTime,
        closingTime,
        latitude,
        longitude,
        distance,
        images,
      ];
}
