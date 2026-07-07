import 'package:db_core/commons_constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'venue_schedule.g.dart';

@JsonSerializable()
class VenueWeek {
  final String? scheduleWeek;
  final String? scheduleDate;
  final int? scheduleStatus; // 0=Available, 1=Unavailable

  VenueWeek({
    this.scheduleWeek,
    this.scheduleDate,
    this.scheduleStatus,
  });

  factory VenueWeek.fromJson(Dictionary json) => _$VenueWeekFromJson(json);
  Dictionary toJson() => _$VenueWeekToJson(this);
}

@JsonSerializable()
class VenueSpaceSlot {
  final int? spaceId;
  final String? spaceName;
  final int? venueTypeId;
  final String? slotDate;
  final String? slotDateShort;
  final List<VenueSlot>? slots;

  VenueSpaceSlot({
    this.spaceId,
    this.spaceName,
    this.venueTypeId,
    this.slotDate,
    this.slotDateShort,
    this.slots,
  });

  factory VenueSpaceSlot.fromJson(Dictionary json) => _$VenueSpaceSlotFromJson(json);
  Dictionary toJson() => _$VenueSpaceSlotToJson(this);
}

@JsonSerializable()
class VenueSlot {
  final int? id;
  final int? spaceId;
  String? slotDate;
  String? spaceName;
  final String? slotStartTime;
  final String? slotEndTime;
  final double? slotPrice;
  final int? slotStatus; // 0=Available, 1=Booked
  final int? dayOfWeek;
  String? uniqueKey;

  VenueSlot({
    this.id,
    this.spaceId,
    this.slotDate,
    this.spaceName,
    this.slotStartTime,
    this.slotEndTime,
    this.slotPrice,
    this.slotStatus,
    this.dayOfWeek,
    this.uniqueKey,
  });

  factory VenueSlot.fromJson(Dictionary json) => _$VenueSlotFromJson(json);
  Dictionary toJson() => _$VenueSlotToJson(this);
}
