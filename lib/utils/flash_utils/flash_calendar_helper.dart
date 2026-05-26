/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 13:27
 */

import 'package:coffee_bean/utils/flash_utils/flash_calendar_config.dart';
import 'package:db_core/utils/flash_utils/flash_calendar_helper.dart';
import 'package:flutter/material.dart';

class FlashCalendarHelper {
  
  /// Wrapper for DbFlashCalendarHelper.showPicker
  static Future<FlashDateTimePickerResult?> showPicker({
    required BuildContext context,
    String? title,
    FlashDateTimePickerMode mode = FlashDateTimePickerMode.dateTime,
    CalendarSelectionType selectionType = CalendarSelectionType.single,
    DateTime? initialDate,
    TimeOfDay? initialTime,
    FlashCalendarConfig? config,
  }) async {
    // Use project-specific default config if none provided
    final cfg = config ??
        FlashCalendarConfig.coffeeBean(
          mode: mode,
          selectionType: selectionType,
          initialDate: initialDate,
          initialTime: initialTime,
        );

    return DbFlashCalendarHelper.showPicker(
      context: context,
      title: title,
      mode: mode,
      selectionType: selectionType,
      initialDate: initialDate,
      initialTime: initialTime,
      config: cfg,
    );
  }
}
