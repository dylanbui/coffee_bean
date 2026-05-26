/*
 * Created with Android Studio
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 13:24
 * Description: Configuration for Flash Calendar Picker.
 */

import 'package:flutter/material.dart';

/// Display modes for the Picker
enum DbFlashDateTimePickerMode {
  /// Date selection only
  dateOnly,
  /// Time selection only
  timeOnly,
  /// Both date and time (Default)
  dateTime
}

/// Selection types for TableCalendar
enum DbCalendarSelectionType { 
  /// Single day selection
  single, 
  /// Date range selection
  range, 
  /// Multiple dates selection
  multi 
}

/// Result data returned after pressing "Confirm"
class DbFlashDateTimePickerResult {
  /// List of selected dates
  final List<DateTime> selectedDates;
  /// Start of the selected range (if applicable)
  final DateTime? rangeStart;
  /// End of the selected range (if applicable)
  final DateTime? rangeEnd;
  /// Selected time of day
  final TimeOfDay? selectedTime;

  DbFlashDateTimePickerResult({
    required this.selectedDates,
    this.rangeStart,
    this.rangeEnd,
    this.selectedTime,
  });
}

/// Localization strings for FlashCalendar
class DbFlashCalendarStrings {
  /// Main title of the modal
  final String title;
  /// Text for the confirmation button
  final String confirmText;
  /// Label for the date tab
  final String dateTabLabel;
  /// Label for the time tab
  final String timeTabLabel;
  /// Label shown when a date is selected
  final String dateSelectionLabel;
  /// Label shown when a range is selected
  final String rangeSelectionLabel;
  /// Label shown when a time is selected
  final String timeSelectionLabel;

  const DbFlashCalendarStrings({
    this.title = "Select Time",
    this.confirmText = "CONFIRM",
    this.dateTabLabel = "DATE",
    this.timeTabLabel = "TIME",
    this.dateSelectionLabel = "SELECTED DATE",
    this.rangeSelectionLabel = "SELECTED RANGE",
    this.timeSelectionLabel = "SELECTED TIME",
  });
}

/// Theme configuration for FlashCalendar
class DbFlashCalendarTheme {
  /// Primary color used for buttons and active states
  final Color primaryColor;
  /// Background color of the modal
  final Color backgroundColor;
  /// Color for inactive or secondary elements
  final Color inactiveColor;
  /// Background color for the active tab
  final Color activeTabBackgroundColor;

  const DbFlashCalendarTheme({
    this.primaryColor = Colors.brown,
    this.backgroundColor = Colors.white,
    this.inactiveColor = const Color(0xFF9E9E9E), // Colors.grey
    this.activeTabBackgroundColor = const Color(0xFFEFEBE9), // Colors.brown.shade50
  });
}

/// Main configuration class for FlashCalendar
class DbFlashCalendarConfig {
  /// Display mode (date, time, or both)
  final DbFlashDateTimePickerMode mode;
  /// Selection type (single, range, or multi)
  final DbCalendarSelectionType selectionType;
  /// The earliest day available on the calendar
  final DateTime firstDay;
  /// The latest day available on the calendar
  final DateTime lastDay;
  /// The initial date focused/selected
  final DateTime? initialDate;
  /// The initial time selected
  final TimeOfDay? initialTime;
  /// Localization strings
  final DbFlashCalendarStrings strings;
  /// Theme settings
  final DbFlashCalendarTheme theme;
  /// Date format pattern (e.g., 'dd/MM/yyyy')
  final String dateDisplayPattern;

  DbFlashCalendarConfig({
    this.mode = DbFlashDateTimePickerMode.dateTime,
    this.selectionType = DbCalendarSelectionType.single,
    DateTime? firstDay,
    DateTime? lastDay,
    this.initialDate,
    this.initialTime,
    this.strings = const DbFlashCalendarStrings(),
    this.theme = const DbFlashCalendarTheme(),
    this.dateDisplayPattern = 'dd/MM/yyyy',
  })  : firstDay = firstDay ?? DateTime(2000),
        lastDay = lastDay ?? DateTime(2100);

  /// Default configuration with project-specific settings
  factory DbFlashCalendarConfig.defaultCalendarConfig({
    DbFlashDateTimePickerMode mode = DbFlashDateTimePickerMode.dateTime,
    DbCalendarSelectionType selectionType = DbCalendarSelectionType.single,
    DateTime? initialDate,
    TimeOfDay? initialTime,
    String dateDisplayPattern = 'dd/MM/yyyy',
  }) {
    return DbFlashCalendarConfig(
      mode: mode,
      selectionType: selectionType,
      initialDate: initialDate,
      initialTime: initialTime,
      dateDisplayPattern: dateDisplayPattern,
      theme: const DbFlashCalendarTheme(primaryColor: Colors.brown),
      strings: const DbFlashCalendarStrings(
        title: "Chọn thời gian",
        confirmText: "XÁC NHẬN THỜI GIAN",
        dateTabLabel: "NGÀY",
        timeTabLabel: "GIỜ",
        dateSelectionLabel: "NGÀY ĐANG CHỌN",
        rangeSelectionLabel: "KHOẢNG NGÀY ĐANG CHỌN",
        timeSelectionLabel: "GIỜ ĐANG CHỌN",
      ),
    );
  }
}
