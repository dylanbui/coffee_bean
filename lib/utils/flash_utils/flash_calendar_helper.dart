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

import 'dart:io';
import 'package:coffee_bean/utils/flash_utils/flash_calendar_config.dart';
import 'package:coffee_bean/utils/flash_utils/flash_extension.dart';
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

    return context.showFlashModal<FlashDateTimePickerResult>(
      title: title,
      maxHeightThreshold: 0.9,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Calendar (Ẩn nếu chỉ chọn Giờ)
              if (mode != FlashDateTimePickerMode.timeOnly)
                TableCalendar(
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
                  onDaySelected: (selected, focused) {
                    setState(() {
                      selectedDay = selected;
                      focusedDay = focused;
                      if (selectionType == CalendarSelectionType.multi) {
                        if (multiSelectedDays.any((d) => isSameDay(d, selected))) {
                          multiSelectedDays.removeWhere((d) => isSameDay(d, selected));
                        } else {
                          multiSelectedDays.add(selected);
                        }
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
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(color: Colors.brown, shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(
                      // SỬA TẠI ĐÂY: Chuyển opacity vào màu sắc
                      // Tương lai sử dụng withValues thay cho withOpacity, để hổ trợ phiên bản tốt hơn
                      color: Colors.brown.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    rangeStartDecoration: BoxDecoration(color: Colors.brown, shape: BoxShape.circle),
                    rangeEndDecoration: BoxDecoration(color: Colors.brown, shape: BoxShape.circle),
                  ),
                  headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                ),

              if (mode == FlashDateTimePickerMode.dateTime) const Divider(height: 32),

              // 2. Time Picker (Chỉ hiện khi chọn 1 ngày hoặc chỉ chọn giờ)
              if (mode != FlashDateTimePickerMode.dateOnly && selectionType == CalendarSelectionType.single)
                _buildAdaptiveTimePicker(context, selectedTime, (newTime) {
                  setState(() => selectedTime = newTime);
                }),

              const SizedBox(height: 20),
            ],
          );
        },
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final result = FlashDateTimePickerResult(
              selectedDates: selectionType == CalendarSelectionType.multi ? multiSelectedDays : [selectedDay ?? focusedDay],
              rangeStart: rangeStart,
              rangeEnd: rangeEnd,
              selectedTime: (mode == FlashDateTimePickerMode.dateOnly) ? null : selectedTime,
            );
            Navigator.pop(context, result);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white),
          child: const Text("XÁC NHẬN"),
        ),
      ],
    );
  }

  static Widget _buildAdaptiveTimePicker(BuildContext context, TimeOfDay currentTime, Function(TimeOfDay) onTimeChanged) {
    if (Platform.isIOS) {
      return Column(
        children: [
          const Text(
            "Chọn giờ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          SizedBox(
            height: 150,
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
    return ListTile(
      leading: const Icon(Icons.access_time_filled, color: Colors.brown),
      title: const Text("Giờ thực hiện", style: TextStyle(fontWeight: FontWeight.bold)),
      trailing: Text(
        currentTime.format(context),
        style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      onTap: () async {
        final time = await showTimePicker(context: context, initialTime: currentTime);
        if (time != null) onTimeChanged(time);
      },
    );
  }
}
