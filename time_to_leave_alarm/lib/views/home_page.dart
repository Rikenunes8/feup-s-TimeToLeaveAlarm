import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_to_leave_alarm/components/alarm_card.dart';
import 'package:time_to_leave_alarm/controllers/providers/alarm_provider.dart';
import 'package:time_to_leave_alarm/views/alarm_page.dart';

class MyHomePage extends StatefulWidget {
  static const route = '/';

  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void openCreatePage() {
    Navigator.pushNamed(context, '/create');
  }

  @override
  Widget build(BuildContext context) {
    final alarms = context.watch<AlarmProvider>().alarms;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: ListView.builder(
              itemCount: alarms.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {Navigator.pushNamed(context, AlarmPage.route, arguments: AlarmPageArguments(alarms[index]));},
                  child: AlarmCard(alarm: alarms[index]),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCreatePage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
