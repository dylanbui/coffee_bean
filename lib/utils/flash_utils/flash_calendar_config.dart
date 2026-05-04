/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 13:24
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';

/// Các chế độ hiển thị của Picker
enum FlashDateTimePickerMode {
    dateOnly,   // Chỉ chọn ngày
    timeOnly,   // Chỉ chọn giờ
    dateTime    // Chọn cả ngày và giờ (Mặc định)
}

/// Kiểu chọn ngày của TableCalendar
enum CalendarSelectionType { single, range, multi }

/// Dữ liệu trả về sau khi nhấn "Xác nhận"
class FlashDateTimePickerResult {
    final List<DateTime> selectedDates; // Danh sách các ngày được chọn
    final DateTime? rangeStart;         // Ngày bắt đầu (nếu chọn Range)
    final DateTime? rangeEnd;           // Ngày kết thúc (nếu chọn Range)
    final TimeOfDay? selectedTime;      // Giờ được chọn

    FlashDateTimePickerResult({
        required this.selectedDates,
        this.rangeStart,
        this.rangeEnd,
        this.selectedTime,
    });
}

/// Cấu hình giao diện và hành vi cho FlashCalendar
class FlashCalendarConfig {
    final FlashDateTimePickerMode pickerMode;
    final CalendarSelectionType selectionType;
    final DateTime? firstDay;
    final DateTime? lastDay;
    final DateTime? initialDate;
    final String? title;
    final String? confirmText;
    final String? cancelText;
    final Color? primaryColor;

    FlashCalendarConfig({
        this.pickerMode = FlashDateTimePickerMode.dateTime,
        this.selectionType = CalendarSelectionType.single,
        this.firstDay,
        this.lastDay,
        this.initialDate,
        this.title,
        this.confirmText = 'Xác nhận',
        this.cancelText = 'Hủy',
        this.primaryColor,
    });
}
