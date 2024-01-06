import 'package:flutter/material.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_icon_tile.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_section.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_switch_tile.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';
import 'package:time_to_leave_alarm/views/ringtones_page.dart';

class AlarmSection extends StatefulWidget {
  final AlarmController controller;

  const AlarmSection({super.key, required this.controller});

  @override
  State<AlarmSection> createState() => _AlarmSectionState();
}

class _AlarmSectionState extends State<AlarmSection> {
  @override
  Widget build(BuildContext context) {
    return AlarmSettingsSection(sectionTitle: "Alarm", children: [
      AlarmSettingsIconTile(
          icon: Icons.label,
          child: TextField(
              controller: widget.controller.nameController,
              decoration: const InputDecoration(
                  hintText: "Name",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintStyle:
                      TextStyle(fontSize: 16, color: Colors.black38, fontWeight: FontWeight.w400),
                  labelStyle:
                      TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400)))),
      AlarmSettingsIconTile(
          icon: Icons.music_note,
          child: TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft),
            onPressed: () async {
              final ringtone = await Navigator.pushNamed(context, RingtonesPage.route);
              if (ringtone != null) {
                setState(() {
                  widget.controller.ringtone = (ringtone as Ringtone?)?.title ?? '';
                });
              }
            },
            child: widget.controller.ringtone == ''
                ? const Text("Ringtone",
                    style:
                        TextStyle(fontSize: 16, color: Colors.black38, fontWeight: FontWeight.w400))
                : Text(widget.controller.ringtone,
                    style:
                        const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400)),
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
    ]);
  }
}

class AlarmController {
  bool vibrate = false;
  String ringtone = '';
  TextEditingController nameController = TextEditingController();

  dispose() {
    nameController.dispose();
  }

  void loadAlarm(Alarm alarm) async {
    vibrate = alarm.vibrate;
    ringtone = alarm.ringtone;
    nameController.text = alarm.name;
  }

  void setAlarm(Alarm alarm) {
    alarm.vibrate = vibrate;
    alarm.ringtone = ringtone;
    debugPrint(nameController.text);
    alarm.name = nameController.text;
  }
}
