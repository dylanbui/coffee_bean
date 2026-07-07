// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueWeek _$VenueWeekFromJson(Map<String, dynamic> json) => VenueWeek(
  scheduleWeek: json['scheduleWeek'] as String?,
  scheduleDate: json['scheduleDate'] as String?,
  scheduleStatus: (json['scheduleStatus'] as num?)?.toInt(),
);

Map<String, dynamic> _$VenueWeekToJson(VenueWeek instance) => <String, dynamic>{
  'scheduleWeek': instance.scheduleWeek,
  'scheduleDate': instance.scheduleDate,
  'scheduleStatus': instance.scheduleStatus,
};

VenueSpaceSlot _$VenueSpaceSlotFromJson(Map<String, dynamic> json) =>
    VenueSpaceSlot(
      spaceId: (json['spaceId'] as num?)?.toInt(),
      spaceName: json['spaceName'] as String?,
      venueTypeId: (json['venueTypeId'] as num?)?.toInt(),
      slotDate: json['slotDate'] as String?,
      slotDateShort: json['slotDateShort'] as String?,
      slots: (json['slots'] as List<dynamic>?)
          ?.map((e) => VenueSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VenueSpaceSlotToJson(VenueSpaceSlot instance) =>
    <String, dynamic>{
      'spaceId': instance.spaceId,
      'spaceName': instance.spaceName,
      'venueTypeId': instance.venueTypeId,
      'slotDate': instance.slotDate,
      'slotDateShort': instance.slotDateShort,
      'slots': instance.slots,
    };

VenueSlot _$VenueSlotFromJson(Map<String, dynamic> json) => VenueSlot(
  id: (json['id'] as num?)?.toInt(),
  spaceId: (json['spaceId'] as num?)?.toInt(),
  slotDate: json['slotDate'] as String?,
  slotStartTime: json['slotStartTime'] as String?,
  slotEndTime: json['slotEndTime'] as String?,
  slotPrice: (json['slotPrice'] as num?)?.toDouble(),
  slotStatus: (json['slotStatus'] as num?)?.toInt(),
  dayOfWeek: (json['dayOfWeek'] as num?)?.toInt(),
  uniqueKey: json['uniqueKey'] as String?,
);

Map<String, dynamic> _$VenueSlotToJson(VenueSlot instance) => <String, dynamic>{
  'id': instance.id,
  'spaceId': instance.spaceId,
  'slotDate': instance.slotDate,
  'slotStartTime': instance.slotStartTime,
  'slotEndTime': instance.slotEndTime,
  'slotPrice': instance.slotPrice,
  'slotStatus': instance.slotStatus,
  'dayOfWeek': instance.dayOfWeek,
  'uniqueKey': instance.uniqueKey,
};
