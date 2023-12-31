import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';
import 'package:time_to_leave_alarm/controllers/api/requests/calculate_distance.dart';
import 'package:time_to_leave_alarm/controllers/api/requests/coordinates_to_address.dart';
import 'package:time_to_leave_alarm/controllers/api/requests/weather.dart';
import 'package:time_to_leave_alarm/controllers/ringtone_manager.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';
import 'package:time_to_leave_alarm/controllers/utils.dart';

import 'database_manager.dart';

const minTimeToRecalculateDistance = 10;
const minTimeToRecalculateDistanceForCurrentLocation = 2;

// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
@pragma('vm:entry-point')
void setAlarmCallback(int id, Map<String, dynamic> params) {
  String message = 'Time to Leave';
  if (!params['name'].isEmpty) message += ' | ${params['name']}';
  if (params["anticipated"]) message += ' | Get ready';
  if (params['weather'] != null) message += ' | ${params['weather']}';
  final intent = AndroidIntent(
    action: 'android.intent.action.SET_ALARM',
    arguments: <String, dynamic>{
      'android.intent.extra.alarm.HOUR': params['hour'],
      'android.intent.extra.alarm.MINUTES': params['minutes'],
      'android.intent.extra.alarm.VIBRATE': params['vibrate'],
      'android.intent.extra.alarm.SKIP_UI': true,
      'android.intent.extra.alarm.MESSAGE': message,
      if (params['ringtone'] != null)'android.intent.extra.alarm.RINGTONE': params['ringtone'],
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
            stringToDateTime(alarm.arriveTime)
                .subtract(Duration(seconds: time)));

        alarm.leaveTime = leaveTimeString;
        alarm.recalculateAndroidAlarmId = Random().nextInt(2147483647);

        DatabaseManager().updateAlarm(alarm);
        if (alarm.turnedOn) {
          setAlarm(alarm);
        } else {
          cancelAlarm(alarm);
        }
      });
}

@pragma('vm:entry-point')
nextPeriodicAlarmCallback(int id, Map<String, dynamic> params) {
  Alarm alarm = Alarm.fromMap(params['alarm']);
  final next = _get_next_periodic_alarm_time(alarm);
  if (next == null) return;
  params['alarm']['arrive_time'] = next;
  recalculateAlarmCallback(alarm.recalculateAndroidAlarmId, params);
}

setAlarm(Alarm alarm) async {
  String? weatherMessage;
  await AndroidAlarmManager.cancel(alarm.recalculateAndroidAlarmId);

  if (stringToDateTime(alarm.leaveTime).isAfter(DateTime.now())) {
    final leaveDatetime = stringToDateTime(alarm.leaveTime);
    int halfDiff =
        (leaveDatetime.difference(DateTime.now()).inMinutes / 2).round();
    if (halfDiff > minTimeToRecalculateDistance) {
      DateTime recalculateDateTime =
          leaveDatetime.subtract(Duration(minutes: halfDiff));
      debugPrint(formatDateTime(recalculateDateTime));
      await AndroidAlarmManager.oneShotAt(recalculateDateTime,
          alarm.recalculateAndroidAlarmId, recalculateAlarmCallback,
          wakeup: true,
          exact: true,
          rescheduleOnReboot: true,
          params: {'alarm': alarm.toMap()});
    } else {
      if (alarm.period) {
        // Trigger recalculation of periodic alarms 5 minutes after they are due
        final rescheduleTime =
            stringToDateTime(alarm.arriveTime).add(const Duration(minutes: 5));
        await AndroidAlarmManager.oneShotAt(rescheduleTime,
            alarm.recalculateAndroidAlarmId, nextPeriodicAlarmCallback,
            wakeup: true,
            exact: true,
            rescheduleOnReboot: true,
            params: {'alarm': alarm.toMap()});
      }

      final coords =
          await convertAddressToCoordinates(address: alarm.destination);
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
  } else if (alarm.period) {
    final rescheduleTime =
        stringToDateTime(alarm.arriveTime).add(Duration(minutes: 5));
    if (rescheduleTime.isAfter(DateTime.now())) {
      await AndroidAlarmManager.oneShotAt(rescheduleTime,
          alarm.recalculateAndroidAlarmId, nextPeriodicAlarmCallback,
          wakeup: true,
          exact: true,
          rescheduleOnReboot: true,
          params: {'alarm': alarm.toMap()});
    } else {
      nextPeriodicAlarmCallback(
          alarm.recalculateAndroidAlarmId, {'alarm': alarm.toMap()});
    }
  }
}

_get_next_periodic_alarm_time(Alarm alarm) {
  final periodData = alarm.periodData.split(",");
  if (periodData.isEmpty) return;

  DateTime? closestAlarm;
  for (String id in periodData) {
    final arriveTime = stringToDateTime(alarm.arriveTime);
    final day = int.parse(id);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nextDay = today.add(Duration(days: day - today.weekday + 1));

    DateTime nextAlarm = DateTime(nextDay.year, nextDay.month, nextDay.day,
        arriveTime.hour, arriveTime.minute);
    if (nextAlarm.isBefore(DateTime.now())) {
      nextAlarm = nextAlarm.add(Duration(days: 7));
    }
    if (closestAlarm == null || nextAlarm.isBefore(closestAlarm)) {
      closestAlarm = nextAlarm;
    }
  }

  return formatDateTime(closestAlarm!);
}

_scheduleSingleAlarm(
    {required DateTime time,
    required int alarmId,
    bool vibrate = false,
    String name = '',
    bool anticipated = false,
    String? ringtone,
    String? weather}) async {
  await AndroidAlarmManager.oneShotAt(
      // Setup an alarm which will call the `callback` function 1 minute before the `anticipatedTime`
      time.subtract(const Duration(minutes: 1)),
      alarmId,
      setAlarmCallback,
      wakeup: true,
      exact: true,
      rescheduleOnReboot: true,
      params: {
        'hour': time.hour,
        'minutes': time.minute,
        'vibrate': vibrate,
        'name': name,
        'anticipated': anticipated,
        'ringtone': ringtone,
        'weather': weather,
      });
}

scheduleAlarm(Alarm alarm, DateTime leaveDatetime, {String? weather}) async {
  Ringtone? ringtone = await findRingtoneFromTitle(alarm.ringtone);
  if (alarm.anticipation > 0) {
    final anticipatedTime =
        leaveDatetime.subtract(Duration(minutes: alarm.anticipation));
    await _scheduleSingleAlarm(
        time: anticipatedTime,
        alarmId: alarm.androidAlarmId + 1,
        vibrate: alarm.vibrate,
        name: alarm.name,
        anticipated: true,
        ringtone: ringtone?.uri,
    );
  }
  await _scheduleSingleAlarm(
      time: leaveDatetime,
      alarmId: alarm.androidAlarmId,
      vibrate: alarm.vibrate,
      name: alarm.name,
      anticipated: false,
      ringtone: ringtone?.uri,
      weather: weather);
}

cancelAlarm(Alarm alarm) async {
  await AndroidAlarmManager.cancel(alarm.androidAlarmId);
  await AndroidAlarmManager.cancel(alarm.androidAlarmId + 1);
  await AndroidAlarmManager.cancel(alarm.recalculateAndroidAlarmId);
}
