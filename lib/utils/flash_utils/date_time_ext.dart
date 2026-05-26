/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 13:21
 * To change this template use File | Settings | File Templates.
 */

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

// extension DateStringExt on String {
//     /// Convert String -> DateTime (Mặc định: dd/MM/yyyy)
//     DateTime? toDateTime({String pattern = 'dd/MM/yyyy'}) {
//         try {
//             return DateFormat(pattern).parse(this);
//         } catch (_) {
//             return null;
//         }
//     }
// }
//
// extension DateIntExt on int {
//     /// Convert Timestamp (milliseconds) -> DateTime
//     DateTime toDateTime() => DateTime.fromMillisecondsSinceEpoch(this);
// }
//
// extension DateTimeFormatExt on DateTime {
//     /// Format nhanh DateTime -> String để hiển thị
//     String toStr({String pattern = 'dd/MM/yyyy'}) => DateFormat(pattern).format(this);
//
//     /// Gộp ngày hiện tại với một TimeOfDay mới
//     DateTime copyWithTime(TimeOfDay? time) {
//         if (time == null) return this;
//         return DateTime(year, month, day, time.hour, time.minute);
//     }
//
//     /// Kiểm tra xem có phải là hôm nay không
//     bool get isToday => isSameDay(DateTime.now());
//
//     /// Kiểm tra xem có phải là ngày mai không
//     bool get isTomorrow => isSameDay(DateTime.now().add(const Duration(days: 1)));
//
//     /// Kiểm tra xem có phải là hôm qua không
//     bool get isYesterday => isSameDay(DateTime.now().subtract(const Duration(days: 1)));
//
//     /// Kiểm tra xem ngày có nằm trong khoảng từ [start] đến [end] không (bao gồm cả hai đầu)
//     bool isBetween(DateTime start, DateTime end) {
//         return (isAfter(start) || isSameDay(start)) &&
//                (isBefore(end) || isSameDay(end));
//     }
//
//     /// Trả về DateTime vào lúc 00:00:00 của ngày hiện tại
//     DateTime get startOfDay => DateTime(year, month, day);
//
//     /// Trả về DateTime vào lúc 23:59:59 của ngày hiện tại
//     DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
//
//     /// Thêm hoặc bớt số ngày
//     DateTime addDays(int days) => add(Duration(days: days));
//
//     /// Lấy ngày đầu tiên của tháng
//     DateTime get firstDayOfMonth => DateTime(year, month, 1);
//
//     /// Lấy ngày cuối cùng của tháng
//     DateTime get lastDayOfMonth => DateTime(year, month + 1, 0);
//
//     /// Kiểm tra xem có cùng tháng và năm không
//     bool isSameMonth(DateTime other) => year == other.year && month == other.month;
//
//     /// Kiểm tra xem có cùng ngày, tháng, năm không
//     bool isSameDay(DateTime other) {
//         return year == other.year && month == other.month && day == other.day;
//     }
// }