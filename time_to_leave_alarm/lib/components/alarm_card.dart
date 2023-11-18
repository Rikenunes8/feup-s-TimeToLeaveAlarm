import 'package:flutter/material.dart';
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
            children: [
              Row(
                children: [
                  Text(
                    timeFromDateTime(widget.alarm.leaveTime),
                    style: const TextStyle(fontSize: 30),
                  ),
                  const SizedBox(width: 10,),
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
              Switch(
                value: true,
                activeColor: Colors.red,
                onChanged: (bool value) {
                  setState(() {});
                },
              )
            ],
          ),
          _address(Icons.circle_outlined, widget.alarm.origin),
          const SizedBox(
            height: 5,
          ),
          _address(Icons.location_on, widget.alarm.destination),
        ],
      ),
    ));
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
    switch (mode) {
      case 'driving':
        return Icons.directions_car_outlined;
    }
    return null;
  }
}
