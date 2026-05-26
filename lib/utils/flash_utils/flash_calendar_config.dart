/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 13:24
 * Description: Project-specific configuration for Flash Calendar.
 */

import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:db_core/utils/flash_utils/flash_calendar_config.dart';
import 'package:flutter/material.dart';

/// Re-exporting base types from db_core for convenience
typedef FlashDateTimePickerMode = DbFlashDateTimePickerMode;
typedef CalendarSelectionType = DbCalendarSelectionType;
typedef FlashDateTimePickerResult = DbFlashDateTimePickerResult;
typedef FlashCalendarStrings = DbFlashCalendarStrings;
typedef FlashCalendarTheme = DbFlashCalendarTheme;

/// Project-specific FlashCalendarConfig inheriting from DbFlashCalendarConfig
class FlashCalendarConfig extends DbFlashCalendarConfig {
  FlashCalendarConfig({
    super.mode = DbFlashDateTimePickerMode.dateTime,
    super.selectionType = DbCalendarSelectionType.single,
    super.firstDay,
    super.lastDay,
    super.initialDate,
    super.initialTime,
    super.strings = const FlashCalendarStrings(
      title: "Chọn thời gian",
      confirmText: "XÁC NHẬN THỜI GIAN",
      dateTabLabel: "NGÀY",
      timeTabLabel: "GIỜ",
      dateSelectionLabel: "NGÀY ĐANG CHỌN",
      rangeSelectionLabel: "KHOẢNG NGÀY ĐANG CHỌN",
      timeSelectionLabel: "GIỜ ĐANG CHỌN",
    ),
    FlashCalendarTheme? theme,
    super.dateDisplayPattern = 'dd/MM/yyyy',
  }) : super(
          theme: theme ??
              const FlashCalendarTheme(
                primaryColor: TMLabsColor.primary,
                activeTabBackgroundColor: TMLabsColor.bgLight,
              ),
        );

  /// Helper factory to create default config for Coffee Bean
  factory FlashCalendarConfig.coffeeBean({
    FlashDateTimePickerMode mode = FlashDateTimePickerMode.dateTime,
    CalendarSelectionType selectionType = CalendarSelectionType.single,
    DateTime? initialDate,
    TimeOfDay? initialTime,
  }) {
    return FlashCalendarConfig(
      mode: mode,
      selectionType: selectionType,
      initialDate: initialDate,
      initialTime: initialTime,
    );
  }

  /// Implementation of copyWith for project-specific usage
  FlashCalendarConfig copyWith({
    FlashDateTimePickerMode? mode,
    CalendarSelectionType? selectionType,
    DateTime? firstDay,
    DateTime? lastDay,
    DateTime? initialDate,
    TimeOfDay? initialTime,
    FlashCalendarStrings? strings,
    FlashCalendarTheme? theme,
    String? dateDisplayPattern,
  }) {
    return FlashCalendarConfig(
      mode: mode ?? this.mode,
      selectionType: selectionType ?? this.selectionType,
      firstDay: firstDay ?? this.firstDay,
      lastDay: lastDay ?? this.lastDay,
      initialDate: initialDate ?? this.initialDate,
      initialTime: initialTime ?? this.initialTime,
      strings: strings ?? this.strings,
      theme: theme ?? this.theme,
      dateDisplayPattern: dateDisplayPattern ?? this.dateDisplayPattern,
    );
  }
}
