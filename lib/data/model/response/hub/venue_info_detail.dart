import 'package:coffee_bean/data/model/json_converters.dart';
import 'package:coffee_bean/data/model/response/hub/venue_info.dart';
import 'package:db_core/commons_constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'venue_info_detail.g.dart';

@JsonSerializable()
class VenueInfoDetail {
  final int id;
  final String venueName;
  
  @SmartListStringConverter()
  final List<String> venueCover;

  final String venueDesc;
  final String venueLocation;
  final String? venuePhone;
  final String venueOpen;
  final String venueClose;
  final double? venuePrice;
  final int? venueCapacity;
  final int? venueStatus;
  final int? venueSort;
  final double latitude;
  final double longitude;
  final String? venueRules;
  final int? businessStatus; // 0=Open, 1=Closed
  
  @SmartListIntConverter()
  final List<int>? venueType;
  
  final List<VenueTypeItem>? venueTypeArray;

  VenueInfoDetail({
    required this.id,
    required this.venueName,
    required this.venueCover,
    required this.venueDesc,
    required this.venueLocation,
    this.venuePhone,
    required this.venueOpen,
    required this.venueClose,
    this.venuePrice,
    this.venueCapacity,
    this.venueStatus,
    this.venueSort,
    required this.latitude,
    required this.longitude,
    this.venueRules,
    this.businessStatus,
    this.venueType,
    this.venueTypeArray,
  });

  factory VenueInfoDetail.fromJson(Dictionary json) => _$VenueInfoDetailFromJson(json);
  Dictionary toJson() => _$VenueInfoDetailToJson(this);
}
