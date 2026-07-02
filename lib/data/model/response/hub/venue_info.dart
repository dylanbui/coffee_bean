import 'package:coffee_bean/data/model/json_converters.dart';
import 'package:db_core/commons_constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'venue_info.g.dart';

@JsonSerializable()
class VenueTypeItem {
  final int id;
  final String label;

  VenueTypeItem({
    required this.id,
    required this.label,
  });

  factory VenueTypeItem.fromJson(Dictionary json) => _$VenueTypeItemFromJson(json);
  Dictionary toJson() => _$VenueTypeItemToJson(this);
}

@JsonSerializable()
class VenueInfo {
  final int id;
  final String venueName;
  final String venueLocation;
  
  @SmartListStringConverter()
  final List<String> venueCover;
  
  final double latitude;
  final double longitude;
  final String venueOpen;
  final String venueClose;
  final double distance;
  final List<VenueTypeItem>? venueTypeArray;

  VenueInfo({
    required this.id,
    required this.venueName,
    required this.venueLocation,
    required this.venueCover,
    required this.latitude,
    required this.longitude,
    required this.venueOpen,
    required this.venueClose,
    required this.distance,
    this.venueTypeArray,
  });

  factory VenueInfo.fromJson(Dictionary json) => _$VenueInfoFromJson(json);

  Dictionary toJson() => _$VenueInfoToJson(this);
}
