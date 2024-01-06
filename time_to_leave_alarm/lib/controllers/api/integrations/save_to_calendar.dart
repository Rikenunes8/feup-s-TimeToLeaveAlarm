import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';
import 'package:time_to_leave_alarm/controllers/utils.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

getWeekDays(String data) {
  var days = data.split(',');
  var weekDays = '';
  for (var day in days) {
    switch (day) {
      case '0':
        weekDays += 'MO,';
        break;
      case '1':
        weekDays += 'TU,';
        break;
      case '2':
        weekDays += 'WE,';
        break;
      case '3':
        weekDays += 'TH,';
        break;
      case '4':
        weekDays += 'FR,';
        break;
      case '5':
        weekDays += 'SA,';
        break;
      case '6':
        weekDays += 'SU,';
        break;
    }
  }
  return weekDays.substring(0, weekDays.length - 1);
}

saveToCalendar({required Alarm alarm}) {
  final Event event = Event(
    title:
        alarm.name.isEmpty ? 'Time to leave' : '${alarm.name} - Time to leave',
    location: alarm.destination,
    startDate: stringToDateTime(alarm.leaveTime),
    endDate: stringToDateTime(alarm.arriveTime),
    allDay: false,
    recurrence: alarm.period
        ? Recurrence(frequency: null, rRule: "FREQ=WEEKLY;BYDAY=${getWeekDays(alarm.periodData)};INTERVAL=1")
        : null,
  );

  Add2Calendar.addEvent2Cal(event);
}
