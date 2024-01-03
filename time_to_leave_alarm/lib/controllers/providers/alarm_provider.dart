import 'dart:collection';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/controllers/database_manager.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';
import 'package:time_to_leave_alarm/controllers/alarm_manager.dart';

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
    setAlarm(alarm);
    notifyListeners();
  }

  updateAlarm(Alarm alarm) {
    _alarms[_alarms.indexOf(alarm)] = alarm;
    DatabaseManager().updateAlarm(alarm);

    if (alarm.turnedOn) {
      setAlarm(alarm);
    } else {
      cancelAlarm(alarm);
    }
    notifyListeners();
  }

  deleteAlarm(Alarm alarm) {
    _alarms.remove(alarm);
    if (alarm.id != null) {
      // TODO aparently alarms for some reason don't have ID. i think the problem is in creation, they are not saved in the database
      //      this doesn't fix it but at least sweeps the issue under the rug if these kinds of things happen
      DatabaseManager().deleteAlarm(alarm.id!);
    }
    cancelAlarm(alarm);
    notifyListeners();
  }
}
