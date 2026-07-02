// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueDetailResponse _$VenueDetailResponseFromJson(Map<String, dynamic> json) =>
    VenueDetailResponse(
      id: (json['id'] as num).toInt(),
      venueName: json['venueName'] as String,
      venueCover: const SmartListStringConverter().fromJson(json['venueCover']),
      venueDesc: json['venueDesc'] as String,
      venueLocation: json['venueLocation'] as String,
      venuePhone: json['venuePhone'] as String,
      venueOpen: json['venueOpen'] as String,
      venueClose: json['venueClose'] as String,
      venuePrice: (json['venuePrice'] as num).toDouble(),
      venueCapacity: (json['venueCapacity'] as num).toInt(),
      venueStatus: (json['venueStatus'] as num?)?.toInt(),
      venueSort: (json['venueSort'] as num?)?.toInt(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      venueRules: json['venueRules'] as String,
      businessStatus: (json['businessStatus'] as num).toInt(),
      venueTypeArray: (json['venueTypeArray'] as List<dynamic>?)
          ?.map((e) => VenueTypeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VenueDetailResponseToJson(
  VenueDetailResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'venueName': instance.venueName,
  'venueCover': const SmartListStringConverter().toJson(instance.venueCover),
  'venueDesc': instance.venueDesc,
  'venueLocation': instance.venueLocation,
  'venuePhone': instance.venuePhone,
  'venueOpen': instance.venueOpen,
  'venueClose': instance.venueClose,
  'venuePrice': instance.venuePrice,
  'venueCapacity': instance.venueCapacity,
  'venueStatus': instance.venueStatus,
  'venueSort': instance.venueSort,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'venueRules': instance.venueRules,
  'businessStatus': instance.businessStatus,
  'venueTypeArray': instance.venueTypeArray,
};
