import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_icon_tile.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_section.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_switch_tile.dart';

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
              ))
      ),
      AlarmSettingsIconTile(icon: Icons.music_note, child: TextButton(
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
      const AlarmSettingsSwitchTile(icon: Icons.vibration, text: "Vibrate"),
      const AlarmSettingsSwitchTile(icon: Icons.snooze, text: "Snooze")
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
}
