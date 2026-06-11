import 'package:db_core/db_core.dart';

class VenueDateModel extends Equatable {
  final DateTime date;
  final bool isAvailable;

  const VenueDateModel({required this.date, this.isAvailable = true});

  @override
  List<Object?> get props => [date, isAvailable];
}

class VenueCourtModel extends Equatable {
  final String id;
  final String name;

  const VenueCourtModel({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class VenueBookingSlot extends Equatable {
  final DateTime date;
  final String courtId;
  final String time;
  final double price;
  final bool isBooked;

  const VenueBookingSlot({
    required this.date,
    required this.courtId,
    required this.time,
    required this.price,
    this.isBooked = false,
  });

  @override
  List<Object?> get props => [date, courtId, time, price, isBooked];
}

class VenueDetailState extends BaseBlocState {
  final DateTime selectedDate;
  final String selectedTab;
  final List<VenueBookingSlot> selectedSlots;
  final List<VenueCourtModel> courts;
  final List<String> timeSlots;
  final List<VenueBookingSlot> allSlots;
  final List<VenueDateModel> weekDates;

  VenueDetailState({
    required this.selectedDate,
    this.selectedTab = 'Sân Pickle ball',
    this.selectedSlots = const [],
    this.courts = const [],
    this.timeSlots = const [],
    this.allSlots = const [],
    this.weekDates = const [],
  });

  @override
  List<Object?> get props => [
        selectedDate,
        selectedTab,
        selectedSlots,
        courts,
        timeSlots,
        allSlots,
        weekDates,
      ];

  VenueDetailState copyWith({
    DateTime? selectedDate,
    String? selectedTab,
    List<VenueBookingSlot>? selectedSlots,
    List<VenueCourtModel>? courts,
    List<String>? timeSlots,
    List<VenueBookingSlot>? allSlots,
    List<VenueDateModel>? weekDates,
  }) {
    return VenueDetailState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedSlots: selectedSlots ?? this.selectedSlots,
      courts: courts ?? this.courts,
      timeSlots: timeSlots ?? this.timeSlots,
      allSlots: allSlots ?? this.allSlots,
      weekDates: weekDates ?? this.weekDates,
    );
  }

  double get totalAmount {
    return selectedSlots.fold(0, (sum, slot) => sum + slot.price);
  }
}
