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
  venueName: json['venueName'] as String? ?? '',
  venueCover: json['venueCover'] == null
      ? const []
      : const SmartListStringConverter().fromJson(json['venueCover']),
  venueLocation: json['venueLocation'] as String? ?? '',
  venueOpen: json['venueOpen'] as String? ?? '',
  venueClose: json['venueClose'] as String? ?? '',
  venuePrice: (json['venuePrice'] as num?)?.toDouble() ?? 0.0,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
  businessStatus: (json['businessStatus'] as num?)?.toInt() ?? 0,
  venueType: const SmartListIntConverter().fromJson(json['venueType']),
  venueTypeArray: (json['venueTypeArray'] as List<dynamic>?)
      ?.map((e) => VenueTypeItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$VenueInfoToJson(VenueInfo instance) => <String, dynamic>{
  'id': instance.id,
  'venueName': instance.venueName,
  'venueCover': const SmartListStringConverter().toJson(instance.venueCover),
  'venueLocation': instance.venueLocation,
  'venueOpen': instance.venueOpen,
  'venueClose': instance.venueClose,
  'venuePrice': instance.venuePrice,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'distance': instance.distance,
  'businessStatus': instance.businessStatus,
  'venueType': _$JsonConverterToJson<Object?, List<int>>(
    instance.venueType,
    const SmartListIntConverter().toJson,
  ),
  'venueTypeArray': instance.venueTypeArray,
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
