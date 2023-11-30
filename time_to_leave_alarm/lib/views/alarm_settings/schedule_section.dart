import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_icon_tile.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_section.dart';

class ScheduleSection extends StatefulWidget {
  final ScheduleController controller;

  const ScheduleSection({Key? key, required this.controller}) : super(key: key);

  @override
  State<ScheduleSection> createState() => _ScheduleSectionState();
}

class _ScheduleSectionState extends State<ScheduleSection> {
  @override
  Widget build(BuildContext context) {
    return AlarmSettingsSection(sectionTitle: "Schedule", children: [
      AlarmSettingsIconTile(
          icon: Icons.access_time_filled,
          child: SizedBox(
            width: 100,
            child: DateTimeField(
                decoration: const InputDecoration(
                  hintText: 'Select arrival time',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                selectedDate: widget.controller.dateTime,
                onDateSelected: (DateTime value) {
                  setState(() {
                    widget.controller.dateTime = value;
                  });
                }),
          )),
      AlarmSettingsIconTile(
          icon: Icons.repeat,
          child: TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft),
            onPressed: () {},
            child: const Text(
              "Does not repeat",
              style: TextStyle(fontSize: 16, color: Colors.black38),
            ),
          )),
    ]);
  }
}

class ScheduleController{
  DateTime? dateTime;
}
