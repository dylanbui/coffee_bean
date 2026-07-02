import 'package:coffee_bean/data/model/json_converters.dart';
import 'package:coffee_bean/data/model/response/hub/venue_info.dart';
import 'package:db_core/commons_constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'venue_detail_response.g.dart';

@JsonSerializable()
class VenueDetailResponse {
  final int id;
  final String venueName;
  
  @SmartListStringConverter()
  final List<String> venueCover;

  final String venueDesc;
  final String venueLocation;
  final String venuePhone;
  final String venueOpen;
  final String venueClose;
  final double venuePrice;
  final int venueCapacity;
  final int? venueStatus;
  final int? venueSort;
  final double latitude;
  final double longitude;
  final String venueRules;
  final int businessStatus; // 0=Open, 1=Closed
  final List<VenueTypeItem>? venueTypeArray;

  VenueDetailResponse({
    required this.id,
    required this.venueName,
    required this.venueCover,
    required this.venueDesc,
    required this.venueLocation,
    required this.venuePhone,
    required this.venueOpen,
    required this.venueClose,
    required this.venuePrice,
    required this.venueCapacity,
    this.venueStatus,
    this.venueSort,
    required this.latitude,
    required this.longitude,
    required this.venueRules,
    required this.businessStatus,
    this.venueTypeArray,
  });

  factory VenueDetailResponse.fromJson(Dictionary json) => _$VenueDetailResponseFromJson(json);
  Dictionary toJson() => _$VenueDetailResponseToJson(this);
}
