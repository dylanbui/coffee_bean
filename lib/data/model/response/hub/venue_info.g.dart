// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueTypeItem _$VenueTypeItemFromJson(Map<String, dynamic> json) =>
    VenueTypeItem(
      id: (json['id'] as num).toInt(),
      label: json['label'] as String,
    );

Map<String, dynamic> _$VenueTypeItemToJson(VenueTypeItem instance) =>
    <String, dynamic>{'id': instance.id, 'label': instance.label};

VenueInfo _$VenueInfoFromJson(Map<String, dynamic> json) => VenueInfo(
  id: (json['id'] as num).toInt(),
  venueName: json['venueName'] as String,
  venueLocation: json['venueLocation'] as String,
  venueCover: const SmartListStringConverter().fromJson(json['venueCover']),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  venueOpen: json['venueOpen'] as String,
  venueClose: json['venueClose'] as String,
  distance: (json['distance'] as num).toDouble(),
  venueTypeArray: (json['venueTypeArray'] as List<dynamic>?)
      ?.map((e) => VenueTypeItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$VenueInfoToJson(VenueInfo instance) => <String, dynamic>{
  'id': instance.id,
  'venueName': instance.venueName,
  'venueLocation': instance.venueLocation,
  'venueCover': const SmartListStringConverter().toJson(instance.venueCover),
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'venueOpen': instance.venueOpen,
  'venueClose': instance.venueClose,
  'distance': instance.distance,
  'venueTypeArray': instance.venueTypeArray,
};
