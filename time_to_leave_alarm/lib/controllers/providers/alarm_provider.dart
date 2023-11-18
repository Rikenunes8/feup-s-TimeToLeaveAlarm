import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/controllers/database_manager.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';


class AlarmProvider with ChangeNotifier {

  List<Alarm> _alarms = [];

  UnmodifiableListView<Alarm> get alarms => UnmodifiableListView(_alarms);

  fetchAlarmsFromDatabase() async {
    _alarms = await DatabaseManager().getAlarms();
    notifyListeners();
  }

  addAlarm(Alarm alarm) {
    _alarms.add(alarm);
    DatabaseManager().insertAlarm(alarm);
    notifyListeners();
  }

  updateAlarm(Alarm alarm) {
    _alarms[_alarms.indexOf(alarm)] = alarm;
    DatabaseManager().updateAlarm(alarm);
    notifyListeners();
  }

  deleteAlarm(Alarm alarm) {
    _alarms.remove(alarm);
    DatabaseManager().deleteAlarm(alarm.id!);
    notifyListeners();
  }
}
