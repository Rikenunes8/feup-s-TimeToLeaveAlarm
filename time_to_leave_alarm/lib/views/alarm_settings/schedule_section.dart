import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_icon_tile.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_section.dart';
import 'package:time_to_leave_alarm/components/week_days.dart';
import 'package:time_to_leave_alarm/controllers/utils.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';

class ScheduleSection extends StatefulWidget {
  final ScheduleController controller;

  const ScheduleSection({super.key, required this.controller});

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
                    hintStyle:
                        TextStyle(fontSize: 16, color: Colors.black38, fontWeight: FontWeight.w400),
                    labelStyle:
                        TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400)),
                selectedDate: widget.controller.dateTime,
                onDateSelected: (DateTime value) {
                  setState(() {
                    widget.controller.dateTime = value;
                  });
                }),
          )),
      AlarmSettingsIconTile(
        icon: Icons.snooze,
        child: TextField(
          controller: widget.controller.anticipation,
          decoration: const InputDecoration(
            hintText: "Anticipation time (min)",
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintStyle: TextStyle(fontSize: 16, color: Colors.black38, fontWeight: FontWeight.w400),
            labelStyle: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400)
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
        ),
      ),
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
                  style: const TextStyle(
                      fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ),
              widget.controller.repeat
                  ? WeekDaysChips(
                      selected: widget.controller.repeatValues,
                      callback: (weekDay) {
                        setState(() {
                          late List<String> selectList;
                          if (widget.controller.repeatValues.isEmpty) {
                            selectList = [];
                          } else {
                            selectList = widget.controller.repeatValues.split(",");
                          }

                          if (selectList.contains(weekDay.toString())) {
                            selectList.remove(weekDay.toString());
                          } else {
                            selectList.add(weekDay.toString());
                          }
                          widget.controller.repeatValues = selectList.join(",");
                        });
                      },
                    )
                  : Container()
            ],
          )),
    ]);
  }
}

class ScheduleController {
  final anticipation = TextEditingController();
  DateTime? dateTime;
  bool repeat = false;
  String repeatValues = "";

  void loadAlarm(Alarm alarm) {
    dateTime = stringToDateTime(alarm.arriveTime);
    anticipation.text = alarm.anticipation == 0 ? '' : alarm.anticipation.toString();
    repeat = alarm.period;
    repeatValues = alarm.periodData;
  }

  void setAlarm(Alarm alarm) {
    alarm.arriveTime = formatDateTime(dateTime!);
    alarm.anticipation = anticipation.text != '' ? int.parse(anticipation.text) : 0;
    alarm.period = repeat;
    alarm.periodData = repeatValues;
  }
}
