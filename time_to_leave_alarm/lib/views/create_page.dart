import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
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

class CreatePage extends StatefulWidget {
  static const route = '/create';

  const CreatePage({super.key, required this.title});

  final String title;

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final DestinationsController destinationsController =
      DestinationsController();
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
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
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => calculateDistance(
            origin: destinationsController.fromController.text.toString(),
            destination: destinationsController.toController.text.toString(),
            then: (time) {
              final arrivalTime = formatDateTime(scheduleController.dateTime!);
              final leaveTime = scheduleController.dateTime != null
                  ? formatDateTime(scheduleController.dateTime!
                      .subtract(Duration(seconds: time)))
                  : arrivalTime;
              final alarm = Alarm(
                  arrivalTime,
                  leaveTime,
                  destinationsController.fromController.text.toString(),
                  destinationsController.toController.text.toString(),
                  mode: transportController.mean.toString());
              context.read<AlarmProvider>().addAlarm(alarm);

              if (scheduleController.dateTime != null) {
                // TODO: This is sketchy
                FlutterAlarmClock.createAlarm(
                    hour: scheduleController.dateTime!.hour,
                    minutes: scheduleController.dateTime!.minute,
                    title: "Time to leave");
              }

              Navigator.pop(context);
            }),
        child: const Icon(Icons.check),
      ),
    );
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
