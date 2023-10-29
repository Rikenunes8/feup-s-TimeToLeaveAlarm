import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_to_leave_alarm/controllers/providers/example_provider.dart';
import 'package:time_to_leave_alarm/theme.dart';
import 'package:time_to_leave_alarm/views/home_page.dart';
import 'package:time_to_leave_alarm/views/map_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ExampleProvider exampleProvider = ExampleProvider()
    return MultiProvider(
        providers: [
          // ChangeNotifierProvider<ExampleProvider>.value(value: exampleProvider),
          ChangeNotifierProvider(create: (_) => ExampleProvider()),
        ],
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: AppTheme.theme,
            initialRoute: MyHomePage.route,
            routes: {
              MyHomePage.route: (context) =>
                  const MyHomePage(title: 'Flutter Demo Home Page'),
              MapPage.route: (context) => const MapPage(title: 'Map Page'),
            },
          );
        });
  }
}
