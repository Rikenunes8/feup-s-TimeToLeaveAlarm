import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:time_to_leave_alarm/controllers/utils.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';

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

class AlarmDataSource extends CalendarDataSource {
  Color color;

  AlarmDataSource(List<Alarm> source, {this.color = Colors.white}) {
    appointments = source;
  }

  @override
  Object? getId(int index) {
    return appointments![index].id;
  }

  @override
  Object? getRecurrenceId(int index) {
    final alarm = appointments![index];
    if (alarm.period) {
      return appointments![index].id;
    }
    return null;
  }

  @override
  DateTime getStartTime(int index) {
    return stringToDateTime(appointments![index].leaveTime);
  }

  @override
  DateTime getEndTime(int index) {
    return stringToDateTime(appointments![index].arriveTime);
  }

  @override
  String getSubject(int index) {
    final alarm = appointments![index];
    return alarm.name.isEmpty ? alarm.destination : alarm.name;
  }

  @override
  Color getColor(int index) {
    return color;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }

  @override
  String? getRecurrenceRule(int index) {
    final alarm = appointments![index];
    if (alarm.period) {
      return "FREQ=WEEKLY;BYDAY=${getWeekDays(alarm.periodData)};INTERVAL=1";
    }
    return null;
  }

  @override
  List<DateTime>? getRecurrenceExceptionDates(int index) {
    return List.empty();
  }

  @override
  Object? convertAppointmentToObject(
      Object? customData, Appointment appointment) {
    return customData;
  }
}
