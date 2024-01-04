import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/controllers/api/requests/calculate_distance.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';
import 'package:time_to_leave_alarm/controllers/utils.dart';

import 'database_manager.dart';

// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
@pragma('vm:entry-point')
void setAlarmCallback(int id, Map<String, dynamic> params) {
  final intent = AndroidIntent(
    action: 'android.intent.action.SET_ALARM',
    arguments: <String, dynamic>{
      'android.intent.extra.alarm.HOUR': params['hour'],
      'android.intent.extra.alarm.MINUTES': params['minutes'],
      'android.intent.extra.alarm.SKIP_UI': true,
      'android.intent.extra.alarm.MESSAGE': 'Time to Leave${params["name"].isEmpty
          ? ''
          : ' - ${params["name"]}'}',
    },
  );
  intent.launch();
}

@pragma('vm:entry-point')
void recalculateAlarmCallback(int id, Map<String, dynamic> params) {
  Alarm alarm = Alarm.fromMap(params['alarm']);
  calculateDistance(
      origin: alarm.origin,
      intermediateLocations: [],
      destination: alarm.destination,
      travelMode: alarm.mode,
      avoidFerries: alarm.ferries,
      avoidHighways: alarm.highways,
      avoidTolls: alarm.tolls,
      arrivalTime: stringToDateTime(alarm.arriveTime),
      then: (time) async {
        final leaveTimeString = formatDateTime(
            stringToDateTime(alarm.arriveTime).subtract(Duration(seconds: time)));

        final androidAlarmId = Random().nextInt(2147483647);
        alarm.leaveTime = leaveTimeString;
        alarm.recalculateAndroidAlarmId = androidAlarmId;

        DatabaseManager().updateAlarm(alarm);
        if (alarm.turnedOn) {
          setAlarm(alarm);
        } else {
          cancelAlarm(alarm);
        }
      }
  );
}

setAlarm(Alarm alarm) async {
  final leaveDatetime = stringToDateTime(alarm.leaveTime);
  await AndroidAlarmManager.oneShotAt(
      // Setup an alarm which will call the `callback` function 1 minute before the `leaveDatetime`
      leaveDatetime.subtract(const Duration(minutes: 1)),
      alarm.androidAlarmId,
      setAlarmCallback,
      wakeup: true,
      exact: true,
      rescheduleOnReboot: true,
      params: {
        'hour': leaveDatetime.hour,
        'minutes': leaveDatetime.minute,
        'name': alarm.name,
      });

  await AndroidAlarmManager.cancel(alarm.recalculateAndroidAlarmId);
  int halfDiff = (leaveDatetime
      .difference(DateTime.now())
      .inMinutes / 2).round();
  if (halfDiff > 2) {
    DateTime recalculateDateTime = leaveDatetime.subtract(Duration(minutes: halfDiff));
    debugPrint(formatDateTime(recalculateDateTime));
    await AndroidAlarmManager.oneShotAt(
        recalculateDateTime,
        alarm.recalculateAndroidAlarmId,
        recalculateAlarmCallback,
        wakeup: true,
        exact: true,
        rescheduleOnReboot: true,
        params: {
          'alarm': alarm.toMap()
        }
    );
  }
}

cancelAlarm(Alarm alarm) async {
  await AndroidAlarmManager.cancel(alarm.androidAlarmId);
  await AndroidAlarmManager.cancel(alarm.recalculateAndroidAlarmId);
}
