import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_to_leave_alarm/controllers/providers/alarm_provider.dart';
import 'package:time_to_leave_alarm/controllers/api/integrations/launch_maps.dart';
import 'package:time_to_leave_alarm/controllers/utils.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';

class AlarmCard extends StatefulWidget {
  const AlarmCard({Key? key, required this.alarm}) : super(key: key);

  final Alarm alarm;

  @override
  State<AlarmCard> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      timeFromDateTime(widget.alarm.leaveTime),
                      style: const TextStyle(fontSize: 30),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          modeIcon(widget.alarm.mode),
                          size: 16,
                        ),
                        Text(
                          "Arrive at ${timeFromDateTime(widget.alarm.arriveTime)}",
                          style: const TextStyle(fontSize: 12),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () => {launchAlarmNavigation(widget.alarm)},
                        icon: const Icon(Icons.map)),
                    Switch(
                      value: widget.alarm.turnedOn,
                      onChanged: (bool value) {
                        widget.alarm.turnedOn = value;
                        context.read<AlarmProvider>().updateAlarm(widget.alarm);
                      },
                    ),
                  ],
                ),
              ],
            ),
            _triggerDates(widget.alarm.period, widget.alarm.periodData, stringToDateTime(widget.alarm.leaveTime)),
            _address(Icons.circle, widget.alarm.origin),
            const SizedBox(
              height: 5,
            ),
            _intermediateAddresses(widget.alarm),
            _address(Icons.location_on_outlined, widget.alarm.destination),
          ],
        ),
    ));
  }

  _triggerDates(bool period, String periodData, DateTime leaveTime) {
    late String text;
    if (widget.alarm.period && leaveTime.isBefore(DateTime.now())) {
      late List<String> selectList;
      if (periodData.isEmpty) {
        selectList = [];
      } else {
        selectList = periodData.split(",");
      }

      text = selectList
          .map((id) => switch (id) {
                '0' => 'Mon',
                '1' => 'Tue',
                '2' => 'Wed',
                '3' => 'Thu',
                '4' => 'Fri',
                '5' => 'Sat',
                '6' => 'Sun',
                _ => '',
              })
          .join(', ');
    } else {
      text = DateFormat('dd MMM yyyy').format(leaveTime);
    }
    
    return Row(children: [ 
      Padding(padding: const EdgeInsets.only(bottom: 5), child: 
      Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),),
    ]);
  }

  _intermediateAddresses(Alarm alarm) {
    final intermediateAddressesNotEmpty = alarm
        .getIntermediateLocations()
        .where((element) => element.isNotEmpty)
        .toList();
    return Column(
      children: [
        for (final address in intermediateAddressesNotEmpty)
          Column(children: [
            _address(Icons.circle_outlined, address),
            const SizedBox(height: 5)
          ]),
      ],
    );
  }

  _address(IconData icon, String address) {
    return Row(
      children: [
        Icon(icon, size: 12),
        const SizedBox(
          width: 5,
        ),
        Flexible(
            child: Text(
          address,
          style: const TextStyle(fontSize: 12),
        )),
      ],
    );
  }

  IconData? modeIcon(String mode) {
    switch (mode.toLowerCase()) {
      case 'drive':
        return Icons.directions_car_outlined;
      case 'transit':
        return Icons.directions_transit_outlined;
      case 'walk':
        return Icons.directions_walk_outlined;
      case 'bicycle':
        return Icons.directions_bike;
    }
    return null;
  }
}
