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
  
  @SmartListStringConverter()
  final List<String> venueCover;
  
  final String venueLocation;
  final String venueOpen;
  final String venueClose;
  final double venuePrice;
  final double latitude;
  final double longitude;
  final double distance;
  final int businessStatus;
  
  @SmartListIntConverter()
  final List<int>? venueType;
  
  final List<VenueTypeItem>? venueTypeArray;

  VenueInfo({
    required this.id,
    this.venueName = '',
    this.venueCover = const [],
    this.venueLocation = '',
    this.venueOpen = '',
    this.venueClose = '',
    this.venuePrice = 0.0,
    required this.latitude,
    required this.longitude,
    this.distance = 0.0,
    this.businessStatus = 0,
    this.venueType,
    this.venueTypeArray,
  });

  factory VenueInfo.fromJson(Dictionary json) => _$VenueInfoFromJson(json);
  Dictionary toJson() => _$VenueInfoToJson(this);
}
