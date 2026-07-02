// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueInfo _$VenueInfoFromJson(Map<String, dynamic> json) => VenueInfo(
  id: (json['id'] as num).toInt(),
  venueName: json['venueName'] as String,
  venueLocation: json['venueLocation'] as String?,
  venueCover: json['venueCover'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  venueOpen: json['venueOpen'] as String?,
  venueClose: json['venueClose'] as String?,
  distance: (json['distance'] as num?)?.toDouble(),
);

Map<String, dynamic> _$VenueInfoToJson(VenueInfo instance) => <String, dynamic>{
  'id': instance.id,
  'venueName': instance.venueName,
  'venueLocation': instance.venueLocation,
  'venueCover': instance.venueCover,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'venueOpen': instance.venueOpen,
  'venueClose': instance.venueClose,
  'distance': instance.distance,
};
