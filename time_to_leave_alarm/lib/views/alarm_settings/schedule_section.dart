import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_icon_tile.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_section.dart';
import 'package:time_to_leave_alarm/components/week_days.dart';

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft),
                onPressed: () {
                  setState(() {
                    widget.controller.repeat = !widget.controller.repeat;
                  });
                },
                child: Text(
                  widget.controller.repeat ? "Repeat" : "Does not repeat",
                  style: const TextStyle(fontSize: 16, color: Colors.black38),
                ),
              ),
              widget.controller.repeat
                  ? WeekDaysChips(selected: widget.controller.repeatValues, callback: (weekDay) {
                    setState(() {
                      var selectList = widget.controller.repeatValues.split(",");
                      if (selectList.contains(weekDay.toString())) {
                        selectList.remove(weekDay.toString());
                      } else {
                        selectList.add(weekDay.toString());
                      }
                      widget.controller.repeatValues = selectList.join(",");
                    });
              },)
                  : Container()
            ],
          )),
    ]);
  }
}

class ScheduleController {
  DateTime? dateTime;
  bool repeat = false;
  String repeatValues = "";
}