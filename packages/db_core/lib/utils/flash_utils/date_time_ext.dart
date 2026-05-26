/*
 * Created with Android Studio
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 13:21
 */

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

extension DbDateStringExt on String {
    DateTime? toDateTime({String pattern = 'dd/MM/yyyy'}) {
        try {
            return DateFormat(pattern).parse(this);
        } catch (_) {
            return null;
        }
    }
}

extension DbDateTimeFormatExt on DateTime {
    String toStr({String pattern = 'dd/MM/yyyy'}) => DateFormat(pattern).format(this);

    DateTime copyWithTime(TimeOfDay? time) {
        if (time == null) return this;
        return DateTime(year, month, day, time.hour, time.minute);
    }

    bool isSameDay(DateTime? other) {
        if (other == null) return false;
        return year == other.year && month == other.month && day == other.day;
    }
}
