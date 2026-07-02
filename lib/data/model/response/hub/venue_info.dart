import 'package:db_core/commons_constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'venue_info.g.dart';

@JsonSerializable()
class VenueInfo {
  final int id;
  final String venueName;
  final String? venueLocation;
  final String? venueCover;
  final double? latitude;
  final double? longitude;
  final String? venueOpen;
  final String? venueClose;
  final double? distance;

  VenueInfo({
    required this.id,
    required this.venueName,
    this.venueLocation,
    this.venueCover,
    this.latitude,
    this.longitude,
    this.venueOpen,
    this.venueClose,
    this.distance,
  });

  factory VenueInfo.fromJson(Dictionary json) => _$VenueInfoFromJson(json);

  Dictionary toJson() => _$VenueInfoToJson(this);
}
