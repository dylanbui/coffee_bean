/*
 * Created with Android Studio
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 13:27
 * Description: Core logic for Flash Calendar Picker with Theme and Localization support.
 */

import 'package:db_core/utils/flash_utils/flash_calendar_config.dart';
import 'package:db_core/utils/flash_utils/flash_modal_helper.dart';
import 'package:db_core/utils/flash_utils/date_time_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// Helper class to display a customizable Flash Calendar Picker.
/// Supports date only, time only, and combined date-time selection modes.
class DbFlashCalendarHelper {
  
  /// Displays the calendar picker modal.
  /// 
  /// [context] The BuildContext to show the modal from.
  /// [title] Optional title for the modal. Defaults to the one in [config].
  /// [mode] The picker mode (date, time, or both).
  /// [selectionType] The type of selection (single, range, or multi).
  /// [initialDate] The initial date to focus on.
  /// [initialTime] The initial time to select.
  /// [config] Custom configuration for theme and localization.
  /// [modalStyle] Custom style for the modal container.
  static Future<DbFlashDateTimePickerResult?> showPicker({
    required BuildContext context,
    String? title,
    DbFlashDateTimePickerMode mode = DbFlashDateTimePickerMode.dateTime,
    DbCalendarSelectionType selectionType = DbCalendarSelectionType.single,
    DateTime? initialDate,
    TimeOfDay? initialTime,
    DbFlashCalendarConfig? config,
    DbFlashModalStyle? modalStyle,
  }) async {
    // 1. Initialize configuration (Default to defaultCalendarConfig if not provided)
    final cfg = config ?? DbFlashCalendarConfig.defaultCalendarConfig(
      mode: mode,
      selectionType: selectionType,
      initialDate: initialDate,
      initialTime: initialTime,
    );

    DateTime focusedDay = cfg.initialDate ?? DateTime.now();
    DateTime? selectedDay = cfg.initialDate ?? DateTime.now();
    List<DateTime> multiSelectedDays = [];
    DateTime? rangeStart;
    DateTime? rangeEnd;
    TimeOfDay selectedTime = cfg.initialTime ?? TimeOfDay.now();
    bool isPickingTime = (cfg.mode == DbFlashDateTimePickerMode.timeOnly);

    return DbFlashModalHelper.showSmartModal<DbFlashDateTimePickerResult>(
      context: context,
      title: title ?? cfg.strings.title,
      maxHeightThreshold: 0.9,
      isPersistent: true,
      style: modalStyle,
      child: StatefulBuilder(
        builder: (innerContext, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- 1. Header Switcher / Label ---
              if (cfg.mode == DbFlashDateTimePickerMode.dateTime)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      _buildTabItem(
                        theme: cfg.theme,
                        label: cfg.strings.dateTabLabel,
                        value: selectedDay?.toStr(pattern: cfg.dateDisplayPattern) ?? "...",
                        isActive: !isPickingTime,
                        onTap: () => setState(() => isPickingTime = false),
                      ),
                      const SizedBox(width: 8),
                      _buildTabItem(
                        theme: cfg.theme,
                        label: cfg.strings.timeTabLabel,
                        value: selectedTime.format(context),
                        isActive: isPickingTime,
                        onTap: () => setState(() => isPickingTime = true),
                      ),
                    ],
                  ),
                )
              else if (cfg.mode == DbFlashDateTimePickerMode.timeOnly)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      _buildTabItem(
                        theme: cfg.theme,
                        label: cfg.strings.timeSelectionLabel,
                        value: selectedTime.format(context),
                        isActive: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                )
              else if (cfg.mode == DbFlashDateTimePickerMode.dateOnly)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      _buildTabItem(
                        theme: cfg.theme,
                        label: cfg.selectionType == DbCalendarSelectionType.range 
                          ? cfg.strings.rangeSelectionLabel 
                          : cfg.strings.dateSelectionLabel,
                        value: cfg.selectionType == DbCalendarSelectionType.range 
                          ? "${rangeStart?.toStr(pattern: cfg.dateDisplayPattern) ?? "..." } - ${rangeEnd?.toStr(pattern: cfg.dateDisplayPattern) ?? "..."}"
                          : (cfg.selectionType == DbCalendarSelectionType.multi 
                              ? "${multiSelectedDays.length} days selected"
                              : (selectedDay?.toStr(pattern: cfg.dateDisplayPattern) ?? "...")),
                        isActive: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

              // --- 2. Dynamic Content Area (Calendar or Time Picker) ---
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 300),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isPickingTime
                      ? _buildInlineTimePicker(innerContext, selectedTime, (newTime) {
                          setState(() => selectedTime = newTime);
                        })
                      : _buildCalendarView(
                          cfg: cfg,
                          focusedDay: focusedDay,
                          selectedDay: selectedDay,
                          multiSelectedDays: multiSelectedDays,
                          rangeStart: rangeStart,
                          rangeEnd: rangeEnd,
                          onDaySelected: (selected, focused) {
                            setState(() {
                              focusedDay = focused;
                              if (cfg.selectionType == DbCalendarSelectionType.multi) {
                                if (multiSelectedDays.any((d) => d.isSameDay(selected))) {
                                  multiSelectedDays.removeWhere((d) => d.isSameDay(selected));
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
            final result = DbFlashDateTimePickerResult(
              selectedDates: cfg.selectionType == DbCalendarSelectionType.multi ? multiSelectedDays : [selectedDay ?? focusedDay],
              rangeStart: rangeStart,
              rangeEnd: rangeEnd,
              selectedTime: (cfg.mode == DbFlashDateTimePickerMode.dateOnly) ? null : selectedTime,
            );
            controller.dismiss(result);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: cfg.theme.primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(cfg.strings.confirmText),
        ),
      ],
    );
  }

  /// Builds a tab item for the header switcher.
  static Widget _buildTabItem({
    required DbFlashCalendarTheme theme,
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
            color: isActive ? theme.activeTabBackgroundColor : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isActive ? theme.primaryColor : Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 10, color: isActive ? theme.primaryColor : theme.inactiveColor, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isActive ? theme.primaryColor : Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the main calendar view using TableCalendar.
  static Widget _buildCalendarView({
    required DbFlashCalendarConfig cfg,
    required DateTime focusedDay,
    required DateTime? selectedDay,
    required List<DateTime> multiSelectedDays,
    required DateTime? rangeStart,
    required DateTime? rangeEnd,
    required Function(DateTime, DateTime) onDaySelected,
    required Function(DateTime?, DateTime?, DateTime) onRangeSelected,
  }) {
    return TableCalendar(
      firstDay: cfg.firstDay,
      lastDay: cfg.lastDay,
      focusedDay: focusedDay,
      selectedDayPredicate: (day) {
        if (cfg.selectionType == DbCalendarSelectionType.multi) {
          return multiSelectedDays.any((d) => d.isSameDay(day));
        }
        return day.isSameDay(selectedDay);
      },
      rangeStartDay: rangeStart,
      rangeEndDay: rangeEnd,
      rangeSelectionMode: cfg.selectionType == DbCalendarSelectionType.range ? RangeSelectionMode.enforced : RangeSelectionMode.disabled,
      onDaySelected: onDaySelected,
      onRangeSelected: onRangeSelected,
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(color: cfg.theme.primaryColor, shape: BoxShape.circle),
        todayDecoration: BoxDecoration(color: cfg.theme.primaryColor.withValues(alpha: 0.2), shape: BoxShape.circle),
        rangeStartDecoration: BoxDecoration(color: cfg.theme.primaryColor, shape: BoxShape.circle),
        rangeEndDecoration: BoxDecoration(color: cfg.theme.primaryColor, shape: BoxShape.circle),
        withinRangeTextStyle: TextStyle(color: cfg.theme.primaryColor),
      ),
      headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
    );
  }

  /// Builds an inline time picker using CupertinoDatePicker.
  static Widget _buildInlineTimePicker(BuildContext context, TimeOfDay currentTime, Function(TimeOfDay) onTimeChanged) {
    return Column(
      key: const ValueKey("time_picker"),
      children: [
        const SizedBox(height: 10),
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
