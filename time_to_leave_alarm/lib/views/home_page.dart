import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:time_to_leave_alarm/components/alarm_card.dart';
import 'package:time_to_leave_alarm/controllers/providers/alarm_provider.dart';
import 'package:time_to_leave_alarm/controllers/utils.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';
import 'package:time_to_leave_alarm/models/alarm_data_source.dart';
import 'package:time_to_leave_alarm/views/alarm_page.dart';

class MyHomePage extends StatefulWidget {
  static const route = '/';

  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  void openCreatePage() {
    Navigator.pushNamed(context, '/create');
  }

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alarms = context.watch<AlarmProvider>().alarms;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.list),
            ),
            Tab(
              icon: Icon(Icons.calendar_month),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: alarms.isNotEmpty
                  ? ListView.builder(
                      itemCount: alarms.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AlarmPage.route,
                                arguments: AlarmPageArguments(alarms[index]));
                          },
                          child: AlarmCard(alarm: alarms[index]),
                        );
                      })
                  : const Text(
                      "No alarms yet. Press the + button to create one.",
                      style: TextStyle(color: Colors.black38, fontSize: 12),
                    ),
            ),
          ),
          Center(
              child: SfCalendar(
              view: CalendarView.month,
              monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment),
              dataSource: AlarmDataSource(alarms,
                  color: Theme.of(context).colorScheme.inversePrimary),
              onTap: (CalendarTapDetails details) {
                if (details.appointments != null &&
                    details.appointments!.isNotEmpty) {
                  Navigator.pushNamed(context, AlarmPage.route,
                      arguments:
                          AlarmPageArguments(details.appointments![0] as Alarm));
                }
              },
            )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCreatePage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
