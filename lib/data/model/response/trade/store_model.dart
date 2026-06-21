import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'store_model.g.dart';

@JsonSerializable()
class StoreModel extends Equatable {
  final int id;
  final String name;
  final String? address;
  final String? phone;
  final double latitude;
  final double longitude;
  final double? distance;
  final String? openingTime;
  final String? closingTime;
  final String? logo;
  final List<String>? images;

  const StoreModel({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.distance,
    this.openingTime,
    this.closingTime,
    this.logo,
    this.images,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => _$StoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoreModelToJson(this);

  String? get mainImage {
    if (logo != null && logo!.isNotEmpty) return logo;
    if (images != null && images!.isNotEmpty) return images!.first;
    return null;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        phone,
        latitude,
        longitude,
        distance,
        openingTime,
        closingTime,
        logo,
        images,
      ];
}
