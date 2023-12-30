import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:time_to_leave_alarm/app.dart';
import 'package:time_to_leave_alarm/controllers/providers/alarm_provider.dart';
import 'package:time_to_leave_alarm/theme.dart';
import 'package:time_to_leave_alarm/views/alarm_page.dart';
import 'package:time_to_leave_alarm/views/home_page.dart';
import 'package:time_to_leave_alarm/views/map_page.dart';

void main() async {
  // Be sure to add this line if initialize() call happens before runApp()
  WidgetsFlutterBinding.ensureInitialized();

  await AndroidAlarmManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AlarmProvider alarmProvider = AlarmProvider();
    alarmProvider.fetchAlarmsFromDatabase();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AlarmProvider>.value(value: alarmProvider),
          // ChangeNotifierProvider(create: (_) => AlarmProvider()),
        ],
        builder: (context, child) {
          return MaterialApp(
            title: appTitle,
            theme: AppTheme.theme,
            initialRoute: MyHomePage.route,
            routes: {
              MyHomePage.route: (context) => const MyHomePage(title: appTitle),
              MapPage.route: (context) => const MapPage(title: 'Map'),
              AlarmPage.route: (context) =>
                  const AlarmPage(title: 'Setup Alarm'),
            },
          );
        });
  }
}
