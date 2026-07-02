import 'package:db_core/commons_constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'venue_schedule_response.g.dart';

@JsonSerializable()
class VenueWeekResponse {
  final String? scheduleWeek;
  final String? scheduleDate;
  final int? scheduleStatus; // 0=Available, 1=Unavailable

  VenueWeekResponse({
    this.scheduleWeek,
    this.scheduleDate,
    this.scheduleStatus,
  });

  factory VenueWeekResponse.fromJson(Dictionary json) => _$VenueWeekResponseFromJson(json);
  Dictionary toJson() => _$VenueWeekResponseToJson(this);
}

@JsonSerializable()
class VenueSpaceSlotResponse {
  final int? spaceId;
  final String? spaceName;
  final int? venueTypeId;
  final String? slotDate;
  final String? slotDateShort;
  final List<VenueSlotResponse>? slots;

  VenueSpaceSlotResponse({
    this.spaceId,
    this.spaceName,
    this.venueTypeId,
    this.slotDate,
    this.slotDateShort,
    this.slots,
  });

  factory VenueSpaceSlotResponse.fromJson(Dictionary json) => _$VenueSpaceSlotResponseFromJson(json);
  Dictionary toJson() => _$VenueSpaceSlotResponseToJson(this);
}

@JsonSerializable()
class VenueSlotResponse {
  final int? id;
  final int? spaceId;
  String? slotDate;
  final String? slotStartTime;
  final String? slotEndTime;
  final double? slotPrice;
  final int? slotStatus; // 0=Available, 1=Booked
  final int? dayOfWeek;
  String? uniqueKey;

  VenueSlotResponse({
    this.id,
    this.spaceId,
    this.slotDate,
    this.slotStartTime,
    this.slotEndTime,
    this.slotPrice,
    this.slotStatus,
    this.dayOfWeek,
    this.uniqueKey,
  });

  factory VenueSlotResponse.fromJson(Dictionary json) => _$VenueSlotResponseFromJson(json);
  Dictionary toJson() => _$VenueSlotResponseToJson(this);
}
