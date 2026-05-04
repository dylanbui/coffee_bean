/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 2/5/26 - 13:26
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class FlashDateHelper {
    /// Widget Calendar dạng timeline ngang (Sử dụng cho màn hình Check-in/Daily)
    static Widget buildTimeline(BuildContext context, {
        required DateTime initialDate,
        Function(DateTime)? onDateChange,
    }) {
        return EasyDateTimeLine(
            initialDate: initialDate,
            onDateChange: onDateChange,
            headerProps: const EasyHeaderProps(
                monthPickerType: MonthPickerType.switcher,
                dateFormatter: DateFormatter.fullDateMonthAsStrDY(),
            ),
            dayProps: const EasyDayProps(
                height: 100,
                width: 60,
                dayStructure: DayStructure.dayStrDayNum,
                activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xffE1B171), Color(0xffB88A44)],
                        ),
                    ),
                ),
            ),
        );
    }
}