import 'package:flutter/material.dart';

class AlarmSettingsSwitchTile extends StatefulWidget {
  final IconData icon;
  final String text;

  const AlarmSettingsSwitchTile({Key? key, required this.icon, required this.text}) : super(key: key);

  @override
  State<AlarmSettingsSwitchTile> createState() => _AlarmSettingsSwitchTileState();
}

class _AlarmSettingsSwitchTileState extends State<AlarmSettingsSwitchTile> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(widget.icon),
        const SizedBox(width: 5),
        Expanded(child: Text(widget.text, style: const TextStyle(fontSize: 16, color: Colors.black38, fontWeight: FontWeight.w500),)),
        Switch(value: value, onChanged: (v) {
          setState(() {
            value = v;
          });
        })
      ],
    );
  }
}
