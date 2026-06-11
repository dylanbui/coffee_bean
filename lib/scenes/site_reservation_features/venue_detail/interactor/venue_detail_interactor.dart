import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/venue_detail_builder.dart';
import 'package:db_core/db_core.dart';
import 'package:flutter/material.dart';

class VenueDetailInteractor extends CubitInteractor<VenueDetailRoutable, VenueDetailState> {
  VenueDetailInteractor(VenueDetailRoutable router)
      : super(
          VenueDetailState(selectedDate: DateTime.now()),
          router: router,
        );

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _initMockData();
  }

  void _initMockData() {
    final now = DateTime.now();
    final weekDates = List.generate(7, (index) {
      final date = now.add(Duration(days: index));
      return VenueDateModel(date: date, isAvailable: index != 4); // Giả sử thứ 6 không đặt được
    });

    final courts = [
      const VenueCourtModel(id: '1', name: 'Sân số 1'),
      const VenueCourtModel(id: '2', name: 'Sân số 2'),
      const VenueCourtModel(id: '3', name: 'Sân số 3'),
      const VenueCourtModel(id: '4', name: 'Sân số 4'),
      const VenueCourtModel(id: 'vip1', name: 'VIP 1'),
      const VenueCourtModel(id: 'vip2', name: 'VIP 2'),
    ];

    final timeSlots = [
      '05:00', '06:00', '07:00', '08:00', '09:00', '10:00',
      '11:00', '12:00', '13:00', '14:00', '15:00', '16:00',
      '17:00', '18:00', '19:00', '20:00', '21:00', '22:00'
    ];

    final List<VenueBookingSlot> allSlots = [];
    for (var dateModel in weekDates) {
      for (var time in timeSlots) {
        for (var court in courts) {
          // Mock một số ô đã hết chỗ
          final isBooked = (time == '07:00' && court.id == '2') || (time == '21:00' && court.id == 'vip1');
          allSlots.add(VenueBookingSlot(
            date: dateModel.date,
            courtId: court.id,
            time: time,
            price: 400000,
            isBooked: isBooked,
          ));
        }
      }
    }

    emit(state.copyWith(
      weekDates: weekDates,
      courts: courts,
      timeSlots: timeSlots,
      allSlots: allSlots,
    ));
  }

  void onDateSelected(DateTime date) {
    final dateModel = state.weekDates.firstWhere((d) => DateUtils.isSameDay(d.date, date));
    if (!dateModel.isAvailable) return;

    emit(state.copyWith(selectedDate: date));
  }

  void onTabChanged(String tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  void onSlotTapped(VenueBookingSlot slot) {
    if (slot.isBooked) return;

    final List<VenueBookingSlot> newSelection = List.from(state.selectedSlots);
    final index = newSelection.indexWhere((s) =>
        DateUtils.isSameDay(s.date, slot.date) && s.courtId == slot.courtId && s.time == slot.time);

    if (index != -1) {
      newSelection.removeAt(index);
    } else {
      newSelection.add(slot);
    }
    emit(state.copyWith(selectedSlots: newSelection));
  }

  bool isSlotSelected(VenueBookingSlot slot) {
    return state.selectedSlots.any((s) =>
        DateUtils.isSameDay(s.date, slot.date) && s.courtId == slot.courtId && s.time == slot.time);
  }

  void onNavigateBack() {
    router?.pop();
  }

  void onBookingConfirm() {



    // Handle booking
    iLog("Confirmed booking for ${state.selectedSlots.length} slots. Total: ${state.totalAmount}");
  }
}
