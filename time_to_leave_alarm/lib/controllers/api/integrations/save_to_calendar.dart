import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';
import 'package:time_to_leave_alarm/controllers/utils.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

saveToCalendar({required Alarm alarm}) {
  debugPrint(alarm.leaveTime.toString());
  final Event event = Event(
    title:
        alarm.name.isEmpty ? 'Time to leave' : '${alarm.name} - Time to leave',
    location: alarm.destination,
    startDate: stringToDateTime(alarm.leaveTime),
    endDate: stringToDateTime(alarm.arriveTime),
    allDay: false,
  );
  // TODO: Deal with recurrence

  Add2Calendar.addEvent2Cal(event);
}
