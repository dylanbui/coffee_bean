import 'package:coffee_bean/data/model/response/hub/venue_info_detail.dart';
import 'package:coffee_bean/data/model/response/hub/venue_info.dart';
import 'package:coffee_bean/data/model/response/hub/venue_schedule.dart';
import 'package:db_core/db_core.dart';

class VenueDetailState extends BaseBlocState {
  final int venueId;
  final int venueTypeId; // Initial or passed from list
  final VenueInfoDetail? venueDetail;
  final DateTime selectedDate;
  final List<VenueTypeItem> availableTypes;
  final VenueTypeItem? selectedType;
  final List<VenueSlot> selectedSlots;
  final List<VenueSpaceSlot> spaces;
  final List<String> timeSlots;
  final List<VenueWeek> weekDates;
  final bool isLoading;

  VenueDetailState({
    required this.venueId,
    this.venueTypeId = 0,
    this.venueDetail,
    required this.selectedDate,
    this.availableTypes = const [],
    this.selectedType,
    this.selectedSlots = const [],
    this.spaces = const [],
    this.timeSlots = const [],
    this.weekDates = const [],
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [
        venueId,
        venueTypeId,
        venueDetail,
        selectedDate,
        availableTypes,
        selectedType,
        selectedSlots,
        spaces,
        timeSlots,
        weekDates,
        isLoading,
      ];

  VenueDetailState copyWith({
    int? venueId,
    int? venueTypeId,
    VenueInfoDetail? venueDetail,
    DateTime? selectedDate,
    List<VenueTypeItem>? availableTypes,
    VenueTypeItem? selectedType,
    List<VenueSlot>? selectedSlots,
    List<VenueSpaceSlot>? spaces,
    List<String>? timeSlots,
    List<VenueWeek>? weekDates,
    bool? isLoading,
  }) {
    return VenueDetailState(
      venueId: venueId ?? this.venueId,
      venueTypeId: venueTypeId ?? this.venueTypeId,
      venueDetail: venueDetail ?? this.venueDetail,
      selectedDate: selectedDate ?? this.selectedDate,
      availableTypes: availableTypes ?? this.availableTypes,
      selectedType: selectedType ?? this.selectedType,
      selectedSlots: selectedSlots ?? this.selectedSlots,
      spaces: spaces ?? this.spaces,
      timeSlots: timeSlots ?? this.timeSlots,
      weekDates: weekDates ?? this.weekDates,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  double get totalAmount {
    return selectedSlots.fold(0, (sum, slot) => sum + (slot.slotPrice ?? 0));
  }
}
