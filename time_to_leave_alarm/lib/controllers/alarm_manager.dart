import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';
import 'package:time_to_leave_alarm/controllers/utils.dart';

// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
@pragma('vm:entry-point')
void setAlarmCallback(int id, Map<String, dynamic> params) {
  final intent = AndroidIntent(
    action: 'android.intent.action.SET_ALARM',
    arguments: <String, dynamic>{
      'android.intent.extra.alarm.HOUR': params['hour'],
      'android.intent.extra.alarm.MINUTES': params['minutes'],
      'android.intent.extra.alarm.SKIP_UI': true,
      'android.intent.extra.alarm.MESSAGE': 'Time to Leave${params["name"].isEmpty ? '' : ' - ${params["name"]}'}',
    },
  );
  intent.launch();
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
}

cancelAlarm(Alarm alarm) async {
  await AndroidAlarmManager.cancel(alarm.androidAlarmId);
}
