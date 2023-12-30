import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_icon_tile.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_section.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_switch_tile.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';

class AlarmSection extends StatefulWidget {
  final AlarmController controller;

  const AlarmSection({Key? key, required this.controller}) : super(key: key);

  @override
  State<AlarmSection> createState() => _AlarmSectionState();
}

class _AlarmSectionState extends State<AlarmSection> {
  final nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlarmSettingsSection(sectionTitle: "Alarm", children: [
      AlarmSettingsIconTile(
          icon: Icons.label,
          child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Name",
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
              ))),
      AlarmSettingsIconTile(
          icon: Icons.music_note,
          child: TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft),
            onPressed: () {},
            child: const Text(
              "Ringtone",
              style: TextStyle(fontSize: 16, color: Colors.black38),
            ),
          )),
      AlarmSettingsSwitchTile(
        icon: Icons.vibration,
        text: "Vibrate",
        initial: widget.controller.vibrate,
        onChanged: (v) {
          setState(() {
            widget.controller.vibrate = v;
          });
        },
      ),
      AlarmSettingsSwitchTile(
        icon: Icons.snooze,
        text: "Snooze",
        initial: widget.controller.snooze,
        onChanged: (v) {
          setState(() {
            widget.controller.snooze = v;
          });
        },
      )
    ]);
  }
}

class AlarmController {
  bool vibrate = false;
  bool snooze = false;
  String ringtone = "";
  TextEditingController nameController = TextEditingController();

  dispose() {
    nameController.dispose();
  }

  void loadAlarm(Alarm alarm) {
    vibrate = alarm.vibrate;
    snooze = alarm.snooze;
    ringtone = alarm.ringtone;
    nameController.text = alarm.name;
  }

  void setAlarm(Alarm alarm) {
    alarm.vibrate = vibrate;
    alarm.snooze = snooze;
    alarm.ringtone = ringtone;
    alarm.name = nameController.text;
  }
}
