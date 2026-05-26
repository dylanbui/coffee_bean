/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 13:27
 * To change this template use File | Settings | File Templates.
 */

/*
 * USAGE EXAMPLES:
 *
 * 1. Chọn 1 Ngày + 1 Giờ (Mặc định):
 * final res = await FlashCalendarHelper.showPicker(context: context);
 *
 * 2. Chọn 1 khoảng ngày (Range):
 * final res = await FlashCalendarHelper.showPicker(
 *    context: context,
 *    mode: FlashPickerMode.dateOnly,
 *    selectionType: CalendarSelectionType.range
 * );
 *
 * 3. Xử lý kết quả:
 * if (res != null) {
 *    print("Ngày đầu tiên: ${res.selectedDates.first}");
 *    print("Giờ: ${res.selectedTime}");
 * }
 */

import 'package:coffee_bean/utils/flash_utils/flash_calendar_config.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
import 'package:coffee_bean/utils/flash_utils/date_time_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class FlashCalendarHelper {
  static Future<FlashDateTimePickerResult?> showPicker({
    required BuildContext context,
    String title = "Chọn thời gian",
    FlashDateTimePickerMode mode = FlashDateTimePickerMode.dateTime,
    CalendarSelectionType selectionType = CalendarSelectionType.single,
    DateTime? initialDate,
    TimeOfDay? initialTime,
  }) async {
    DateTime focusedDay = initialDate ?? DateTime.now();
    DateTime? selectedDay = initialDate ?? DateTime.now();
    List<DateTime> multiSelectedDays = [];
    DateTime? rangeStart;
    DateTime? rangeEnd;
    TimeOfDay selectedTime = initialTime ?? TimeOfDay.now();
    bool isPickingTime = (mode == FlashDateTimePickerMode.timeOnly);

    return context.showFlashModal<FlashDateTimePickerResult>(
      title: title,
      maxHeightThreshold: 0.9,
      isPersistent: true,
      child: StatefulBuilder(
        builder: (innerContext, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Header Switcher (Nếu là mode dateTime)
              if (mode == FlashDateTimePickerMode.dateTime)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      _buildTabItem(
                        label: "NGÀY",
                        value: selectedDay?.toStr() ?? "Chọn ngày",
                        isActive: !isPickingTime,
                        onTap: () => setState(() => isPickingTime = false),
                      ),
                      const SizedBox(width: 8),
                      _buildTabItem(
                        label: "GIỜ",
                        value: selectedTime.format(context),
                        isActive: isPickingTime,
                        onTap: () => setState(() => isPickingTime = true),
                      ),
                    ],
                  ),
                )
              else if (mode == FlashDateTimePickerMode.timeOnly)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      _buildTabItem(
                        label: "GIỜ ĐANG CHỌN",
                        value: selectedTime.format(context),
                        isActive: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                )
              else if (mode == FlashDateTimePickerMode.dateOnly)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      _buildTabItem(
                        label: selectionType == CalendarSelectionType.range ? "KHOẢNG NGÀY ĐANG CHỌN" : "NGÀY ĐANG CHỌN",
                        value: selectionType == CalendarSelectionType.range 
                          ? "${rangeStart?.toStr() ?? "..." } - ${rangeEnd?.toStr() ?? "..."}"
                          : (selectionType == CalendarSelectionType.multi 
                              ? "${multiSelectedDays.length} ngày đã chọn"
                              : (selectedDay?.toStr() ?? "Chọn ngày")),
                        isActive: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

              // 2. Nội dung thay đổi dựa trên state
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 300),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isPickingTime
                      ? _buildInlineTimePicker(innerContext, selectedTime, (newTime) {
                          setState(() => selectedTime = newTime);
                        })
                      : _buildCalendarView(
                          mode: mode,
                          selectionType: selectionType,
                          focusedDay: focusedDay,
                          selectedDay: selectedDay,
                          multiSelectedDays: multiSelectedDays,
                          rangeStart: rangeStart,
                          rangeEnd: rangeEnd,
                          onDaySelected: (selected, focused) {
                            setState(() {
                              focusedDay = focused;
                              if (selectionType == CalendarSelectionType.multi) {
                                if (multiSelectedDays.any((d) => isSameDay(d, selected))) {
                                  multiSelectedDays.removeWhere((d) => isSameDay(d, selected));
                                } else {
                                  multiSelectedDays.add(selected);
                                }
                              } else {
                                selectedDay = selected;
                              }
                            });
                          },
                          onRangeSelected: (start, end, focused) {
                            setState(() {
                              rangeStart = start;
                              rangeEnd = end;
                              focusedDay = focused;
                            });
                          },
                        ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
      actionsBuilder: (context, controller) => [
        ElevatedButton(
          onPressed: () {
            final result = FlashDateTimePickerResult(
              selectedDates: selectionType == CalendarSelectionType.multi ? multiSelectedDays : [selectedDay ?? focusedDay],
              rangeStart: rangeStart,
              rangeEnd: rangeEnd,
              selectedTime: (mode == FlashDateTimePickerMode.dateOnly) ? null : selectedTime,
            );
            controller.dismiss(result);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("XÁC NHẬN THỜI GIAN"),
        ),
      ],
    );
  }

  static Widget _buildTabItem({
    required String label,
    required String value,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.brown.shade50 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isActive ? Colors.brown : Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 10, color: isActive ? Colors.brown : Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isActive ? Colors.brown : Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildCalendarView({
    required FlashDateTimePickerMode mode,
    required CalendarSelectionType selectionType,
    required DateTime focusedDay,
    required DateTime? selectedDay,
    required List<DateTime> multiSelectedDays,
    required DateTime? rangeStart,
    required DateTime? rangeEnd,
    required Function(DateTime, DateTime) onDaySelected,
    required Function(DateTime?, DateTime?, DateTime) onRangeSelected,
  }) {
    if (mode == FlashDateTimePickerMode.timeOnly) return const SizedBox.shrink();

    return TableCalendar(
      firstDay: DateTime(2000),
      lastDay: DateTime(2100),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) {
        if (selectionType == CalendarSelectionType.multi) {
          return multiSelectedDays.any((d) => isSameDay(d, day));
        }
        return isSameDay(selectedDay, day);
      },
      rangeStartDay: rangeStart,
      rangeEndDay: rangeEnd,
      rangeSelectionMode: selectionType == CalendarSelectionType.range ? RangeSelectionMode.enforced : RangeSelectionMode.disabled,
      onDaySelected: onDaySelected,
      onRangeSelected: onRangeSelected,
      calendarStyle: CalendarStyle(
        selectedDecoration: const BoxDecoration(color: Colors.brown, shape: BoxShape.circle),
        todayDecoration: BoxDecoration(color: Colors.brown.withOpacity(0.2), shape: BoxShape.circle),
        rangeStartDecoration: const BoxDecoration(color: Colors.brown, shape: BoxShape.circle),
        rangeEndDecoration: const BoxDecoration(color: Colors.brown, shape: BoxShape.circle),
        withinRangeTextStyle: const TextStyle(color: Colors.brown),
      ),
      headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
    );
  }

  static Widget _buildInlineTimePicker(BuildContext context, TimeOfDay currentTime, Function(TimeOfDay) onTimeChanged) {
    return Column(
      key: const ValueKey("time_picker"),
      children: [
        SizedBox(
          height: 300,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: DateTime(2026, 1, 1, currentTime.hour, currentTime.minute),
            use24hFormat: true,
            onDateTimeChanged: (DateTime dt) => onTimeChanged(TimeOfDay.fromDateTime(dt)),
          ),
        ),
      ],
    );
  }
}
