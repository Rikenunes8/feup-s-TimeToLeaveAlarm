import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_to_leave_alarm/controllers/api/requests/calculate_distance.dart';
import 'package:time_to_leave_alarm/controllers/api/widgets/auto_complete_text_field.dart';
import 'package:time_to_leave_alarm/components/my_location_button.dart';
import 'package:time_to_leave_alarm/components/map_location_button.dart';
import 'package:time_to_leave_alarm/controllers/providers/alarm_provider.dart';
import 'package:time_to_leave_alarm/controllers/utils.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';
import 'package:time_to_leave_alarm/views/alarm_settings/alarm_section.dart';
import 'package:time_to_leave_alarm/views/alarm_settings/destinations_section.dart';
import 'package:time_to_leave_alarm/views/alarm_settings/schedule_section.dart';
import 'package:time_to_leave_alarm/views/alarm_settings/transport_section.dart';

class AlarmPageArguments {
  final Alarm alarm;

  AlarmPageArguments(this.alarm);
}

class AlarmPage extends StatefulWidget {
  static const route = '/create';

  const AlarmPage({super.key, required this.title});

  final String title;

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final DestinationsController destinationsController = DestinationsController();
  final ScheduleController scheduleController = ScheduleController();
  final TransportController transportController = TransportController();
  final AlarmController alarmController = AlarmController();

  @override
  void dispose() {
    destinationsController.dispose();
    alarmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as AlarmPageArguments?;
    if (args != null) {
      destinationsController.loadAlarm(args.alarm);
      scheduleController.loadAlarm(args.alarm);
      transportController.loadAlarm(args.alarm);
      alarmController.loadAlarm(args.alarm);
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: <Widget>[
            args?.alarm != null
                ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<AlarmProvider>().deleteAlarm(args!.alarm);
                      Navigator.pop(context);
                    },
                  )
                : Container(),
          ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            DestinationsSection(
              controller: destinationsController,
            ),
            ScheduleSection(
              controller: scheduleController,
            ),
            TransportSection(
              controller: transportController,
            ),
            AlarmSection(controller: alarmController),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createOrUpdateAlarm(args?.alarm),
        child: const Icon(Icons.check),
      ),
    );
  }

  createOrUpdateAlarm(Alarm? alarm) {
    final origin = destinationsController.fromController.text;
    final destination = destinationsController.toController.text;
    final arrivalTime = scheduleController.dateTime;
    if (origin.isEmpty || destination.isEmpty || arrivalTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Required fields empty"),
      ));
      return;
    }

    calculateDistance(
        origin: origin,
        destination: destination,
        then: (time) async {
          final newAlarm = alarm == null;
          final leaveTimeString = formatDateTime(arrivalTime.subtract(Duration(seconds: time)));

          if (newAlarm) {
            final androidAlarmId = Random().nextInt(2147483647);
            alarm = Alarm(leaveTime: leaveTimeString, androidAlarmId: androidAlarmId);
          } else {
            alarm!.leaveTime = leaveTimeString;
            alarm!.turnedOn = true;
          }

          destinationsController.setAlarm(alarm!);
          scheduleController.setAlarm(alarm!);
          transportController.setAlarm(alarm!);
          alarmController.setAlarm(alarm!);

          if (newAlarm) {
            context.read<AlarmProvider>().addAlarm(alarm!);
          } else {
            context.read<AlarmProvider>().updateAlarm(alarm!);
          }

          Navigator.pop(context);
        });
  }

  placesAutoCompleteTextField(String label, TextEditingController controller) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 65,
          child: Text(label),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: AutoCompleteTextField(
              controller: controller,
              hintText: "Search your location",
            ),
          ),
        ),
        MyLocationButton(then: (address) => {controller.text = address}),
        MapLocationButton(then: (address) => {controller.text = address}),
      ],
    );
  }
}
