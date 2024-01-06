import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/controllers/api/requests/calculate_distance.dart';
import 'package:time_to_leave_alarm/controllers/api/requests/coordinates_to_address.dart';
import 'package:time_to_leave_alarm/controllers/api/requests/weather.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';
import 'package:time_to_leave_alarm/controllers/utils.dart';

import 'database_manager.dart';

// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
@pragma('vm:entry-point')
void setAlarmCallback(int id, Map<String, dynamic> params) {
  String message = 'Time to Leave';
  if (!params['name'].isEmpty) message += '\n${params['name']}';
  if (params['weather'] != null) message += '\n${params['weather']}';
  final intent = AndroidIntent(
    action: 'android.intent.action.SET_ALARM',
    arguments: <String, dynamic>{
      'android.intent.extra.alarm.HOUR': params['hour'],
      'android.intent.extra.alarm.MINUTES': params['minutes'],
      'android.intent.extra.alarm.VIBRATE': params['vibrate'],
      'android.intent.extra.alarm.SKIP_UI': true,
      'android.intent.extra.alarm.MESSAGE': message,
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

        alarm.leaveTime = leaveTimeString;
        alarm.recalculateAndroidAlarmId = Random().nextInt(2147483647);

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
  String? weatherMessage;
  final leaveDatetime = stringToDateTime(alarm.leaveTime);

  await AndroidAlarmManager.cancel(alarm.recalculateAndroidAlarmId);
  int halfDiff = (leaveDatetime.difference(DateTime.now()).inMinutes / 2).round();
  if (halfDiff > 10) {
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
  } else {
    final coords = await convertAddressToCoordinates(address: alarm.destination);
    debugPrint(coords.toString());
    if (coords != null) {
      final weather = await getWeather(coords[0], coords[1]);
      if (weather != null) {
        final String description = weather['weather'][0]['description'];
        final temp = weather['main']['temp'];
        weatherMessage = '${description.capitalize()} | $tempºC';
      }
    }
  }

  await scheduleAlarm(alarm, leaveDatetime, weather: weatherMessage);
}

scheduleAlarm(Alarm alarm, DateTime leaveDatetime, {String? weather}) async {
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
        'vibrate': alarm.vibrate,
        'name': alarm.name,
        'weather': weather
      });
}

cancelAlarm(Alarm alarm) async {
  await AndroidAlarmManager.cancel(alarm.androidAlarmId);
  await AndroidAlarmManager.cancel(alarm.recalculateAndroidAlarmId);
}
