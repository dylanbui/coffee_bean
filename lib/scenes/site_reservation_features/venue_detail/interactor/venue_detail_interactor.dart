import 'package:coffee_bean/data/model/response/hub/venue_info.dart';
import 'package:coffee_bean/data/model/response/hub/venue_schedule_response.dart';
import 'package:coffee_bean/data/repository/reservation_repository.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/interactor/venue_detail_event_state.dart';
import 'package:coffee_bean/scenes/site_reservation_features/venue_detail/venue_detail_builder.dart';
import 'package:coffee_bean/utils/currency_utils.dart';
import 'package:db_core/db_core.dart';

class VenueDetailInteractor extends CubitInteractor<VenueDetailRoutable, VenueDetailState> {
  final ReservationRepository _reservationRepository = locator<ReservationRepository>();
  
  VenueDetailInteractor(
    VenueDetailRoutable router, {
    required int venueId,
    int venueTypeId = 0,
  }) : super(
          VenueDetailState(
            venueId: venueId,
            venueTypeId: venueTypeId,
            selectedDate: DateTime.now(),
          ),
          router: router,
        );

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _fetchVenueData();
  }

  Future<void> _fetchVenueData() async {
    // 1. Get Venue Detail
    final detailResult = await _reservationRepository.getVenueDetail(state.venueId);
    if (detailResult case DbSuccess(data: final venueData)) {
      // Use venueTypeArray from BE instead of calling dictionary API
      final availableTypes = venueData.venueTypeArray ?? [];
      
      // Default select the first one, or the one passed from the previous screen
      VenueTypeItem? selectedType;
      if (availableTypes.isNotEmpty) {
        selectedType = availableTypes.firstWhere(
          (t) => t.id == state.venueTypeId,
          orElse: () => availableTypes.first,
        );
      }

      emit(state.copyWith(
        venueDetail: venueData,
        availableTypes: availableTypes,
        selectedType: selectedType,
        venueTypeId: selectedType?.id ?? 0,
      ));

      // 3. Load schedule and slots if we have a type
      if (selectedType != null) {
        _fetchInitialData(selectedType.id);
      }
    }
  }

  Future<void> _fetchInitialData(int typeId) async {
    // 1. Get Week Schedule
    final weekResult = await _reservationRepository.getVenueWeekSchedule(state.venueId, typeId);
    if (weekResult case DbSuccess(data: final data)) {
      emit(state.copyWith(weekDates: data));
      if (data.isNotEmpty) {
        // Tự động tìm ngày đầu tiên "Mở cửa" (status == 0) để load dữ liệu
        final firstAvailableDateModel = data.firstWhere(
          (d) => d.scheduleStatus == 0,
          orElse: () => data.first,
        );

        final firstDate = DateTime.tryParse(firstAvailableDateModel.scheduleDate ?? '') ?? DateTime.now();
        _fetchAvailableSpaces(firstDate, typeId: typeId);
      }
    }
  }

  Future<void> _fetchAvailableSpaces(DateTime date, {int? typeId}) async {
    final targetTypeId = typeId ?? state.selectedType?.id ?? 0;
    if (targetTypeId == 0) return;

    final dateStr = date.toIso8601String().split('T').first;
    final spacesResult = await _reservationRepository.getVenueAvailableSpaces(
      state.venueId,
      targetTypeId,
      dateStr,
    );

    if (spacesResult case DbSuccess(data: final data)) {
      // Extract unique time slots from all spaces
      final Set<String> times = {};
      for (var space in data) {
        if (space.slots != null) {
          for (var slot in space.slots!) {
            // Logic xử lý dữ liệu: Ép slotDate từ cha xuống con để đảm bảo định danh duy nhất (UniqueKey) luôn chính xác khi đổi ngày
            slot.slotDate = space.slotDate;
            slot.uniqueKey = "${space.spaceId}_${space.slotDate}_${slot.slotStartTime}";
            if (slot.slotStartTime != null) times.add(slot.slotStartTime!);
          }
        }
      }
      final sortedTimes = times.toList()..sort();

      emit(state.copyWith(
        selectedDate: date,
        spaces: data,
        timeSlots: sortedTimes,
        isLoading: false,
      ));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  void onDateSelected(DateTime date) {
    // Tìm model ngày tương ứng trong list weekDates
    final targetDateStr = date.toIso8601String().split('T').first;
    final dateModel = state.weekDates.firstWhere(
      (d) => d.scheduleDate == targetDateStr,
      orElse: () => VenueWeekResponse(scheduleStatus: 1), // Mặc định coi như không khả dụng nếu không tìm thấy
    );

    // Nếu ngày là "Không đặt được" (status != 0), chặn không cho chọn và không load API
    if (dateModel.scheduleStatus != 0) return;

    // Cập nhật ngày và bật loading (giữ lại data cũ để không bị giật layout)
    emit(state.copyWith(
      selectedDate: date,
      isLoading: true,
    ));

    // Gọi API load dữ liệu cho ngày mới
    _fetchAvailableSpaces(date);
  }

  void onTabChanged(VenueTypeItem type) {
    if (state.selectedType?.id == type.id) return;

    // Reset danh sách đã chọn khi đổi loại sân (Ví dụ: Sân 5 -> Sân 7)
    // vì thường không thể đặt chung các loại sân khác nhau trong cùng một đơn
    emit(state.copyWith(
      selectedType: type,
      venueTypeId: type.id,
      selectedSlots: [], // Reset lại selection
    ));

    _fetchInitialData(type.id);
  }

  void onSlotTapped(VenueSlotResponse slot) {
    // 1 = Booked. Server dùng id == null để báo slot còn trống, nên không chặn theo ID nữa.
    if (slot.slotStatus == 1) return;

    final List<VenueSlotResponse> newSelection = List.from(state.selectedSlots);
    final index = newSelection.indexWhere((s) => s.uniqueKey == slot.uniqueKey);

    if (index != -1) {
      newSelection.removeAt(index);
    } else {
      newSelection.add(slot);
    }
    emit(state.copyWith(selectedSlots: newSelection));
  }

  bool isSlotSelected(VenueSlotResponse slot) {
    return state.selectedSlots.any((s) => s.uniqueKey == slot.uniqueKey);
  }

  void onNavigateBack() {
    router?.pop();
  }

  void onOpenMapTap() {
    if (state.venueDetail?.venueLocation != null) {
      router?.openMap(state.venueDetail!.venueLocation);
    }
  }

  void onBookingConfirm() {
    if (state.selectedSlots.isEmpty) {
      iLog("No slots selected");
      return;
    }

    iLog("=== XÁC NHẬN ĐẶT LỊCH ===");
    iLog("Tổng số slot: ${state.selectedSlots.length}");
    iLog("Tổng tiền: ${state.totalAmount.toFormatPrice()}");
    
    for (var i = 0; i < state.selectedSlots.length; i++) {
      final slot = state.selectedSlots[i];
      iLog("Slot ${i + 1}: Key=${slot.uniqueKey} | Giá=${slot.slotPrice?.toFormatPrice()}");
    }
    iLog("=========================");

    // Module venue_payment will be replaced, temporarily keeping this logic as is.
  }
}
