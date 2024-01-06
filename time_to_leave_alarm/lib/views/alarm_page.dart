import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_to_leave_alarm/controllers/api/requests/calculate_distance.dart';
import 'package:time_to_leave_alarm/controllers/api/widgets/auto_complete_text_field.dart';
import 'package:time_to_leave_alarm/controllers/api/integrations/save_to_calendar.dart';
import 'package:time_to_leave_alarm/components/my_location_button.dart';
import 'package:time_to_leave_alarm/components/map_location_button.dart';
import 'package:time_to_leave_alarm/controllers/providers/alarm_provider.dart';
import 'package:time_to_leave_alarm/controllers/utils.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';
import 'package:time_to_leave_alarm/views/alarm_settings/alarm_section.dart';
import 'package:time_to_leave_alarm/views/alarm_settings/destinations_section.dart';
import 'package:time_to_leave_alarm/views/alarm_settings/schedule_section.dart';
import 'package:time_to_leave_alarm/views/alarm_settings/transport_section.dart';
import 'package:share_plus/share_plus.dart';

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
  final DestinationsController destinationsController =
      DestinationsController();
  final ScheduleController scheduleController = ScheduleController();
  final TransportController transportController = TransportController();
  final AlarmController alarmController = AlarmController();
  bool editing = false;
  Alarm? alarm;

  @override
  void didChangeDependencies() {
    final args =
        ModalRoute.of(context)?.settings.arguments as AlarmPageArguments?;
    if (args != null) {
      editing = true;
      loadAlarm(args.alarm);
      alarm = args.alarm;
    }
    super.didChangeDependencies();
  }

  void loadAlarm(Alarm alarm) {
    destinationsController.loadAlarm(alarm);
    scheduleController.loadAlarm(alarm);
    transportController.loadAlarm(alarm);
    alarmController.loadAlarm(alarm);
  }

  _AlarmPageState() {
    destinationsController.setOnChange(() => setState(() {
          destinationsController.updateControllers();
        }));
  }

  @override
  void dispose() {
    destinationsController.dispose();
    alarmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: <Widget>[
            editing
                ? PopupMenuButton(
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem(
                          value: "delete",
                          child: Row(children: [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            SizedBox(width: 10),
                            Text("Delete", style: TextStyle(color: Colors.red)),
                          ]),
                        ),
                        const PopupMenuItem(
                          value: "share",
                          child: Row(children: [
                            Icon(Icons.share),
                            SizedBox(width: 10),
                            Text("Send"),
                          ]),
                        ),
                        const PopupMenuItem(
                            value: "save",
                            child: Row(children: [
                              Icon(Icons.calendar_month),
                              SizedBox(width: 10),
                              Text("Save to calendar"),
                            ]))
                      ];
                    },
                    onSelected: (value) {
                      if (value == "delete") {
                        context.read<AlarmProvider>().deleteAlarm(alarm!);
                        Navigator.pop(context);
                      } else if (value == "share") {
                        final code = alarm!.toCode();
                        Share.share(
                            'Use this code to import the alarm in the TimeToLeave App:\n$code');
                      } else if (value == "save") {
                        saveToCalendar(alarm: alarm!);
                      }
                    },
                  )
                : IconButton(
                    onPressed: () {
                      importAlarmDialog();
                    },
                    icon: const Icon(Icons.file_upload_outlined)),
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createOrUpdateAlarm(alarm),
        child: const Icon(Icons.check),
      ),
    );
  }

  Future importAlarmDialog() => showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text("Import alarm"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "ttl.alarm://...",
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  final alarm = Alarm.fromCode(controller.text);
                  if (alarm != null) {
                    Navigator.pop(context);
                    loadAlarm(alarm);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Invalid code"),
                    ));
                  }
                },
                child: const Text("Import")),
          ],
        );
      });

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
        intermediateLocations: destinationsController.intermediateControllers
            .map((e) => e.text.toString())
            .where((e) => e.isNotEmpty)
            .toList(),
        destination: destination,
        travelMode: transportController.mean.toShortString(),
        avoidFerries: transportController.ferries,
        avoidHighways: transportController.highways,
        avoidTolls: transportController.tolls,
        arrivalTime: arrivalTime,
        then: (time) async {
          final newAlarm = alarm == null;
          final leaveTimeString =
              formatDateTime(arrivalTime.subtract(Duration(seconds: time)));

          if (newAlarm) {
            final androidAlarmId = Random().nextInt(2147483647);
            alarm = Alarm(
                leaveTime: leaveTimeString, androidAlarmId: androidAlarmId);
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
