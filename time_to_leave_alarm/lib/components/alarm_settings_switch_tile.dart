import 'package:flutter/material.dart';

class AlarmSettingsSwitchTile extends StatefulWidget {
  final IconData icon;
  final String text;
  final bool initial;
  final Function(bool) onChanged;

  const AlarmSettingsSwitchTile(
      {super.key,
      required this.icon,
      required this.text,
      required this.initial,
      required this.onChanged});

  @override
  State<AlarmSettingsSwitchTile> createState() => _AlarmSettingsSwitchTileState();
}

class _AlarmSettingsSwitchTileState extends State<AlarmSettingsSwitchTile> {
  late bool value;

  @override
  Widget build(BuildContext context) {
    value = widget.initial;
    return Row(
      children: [
        Icon(widget.icon),
        const SizedBox(width: 5),
        Expanded(
            child: Text(
          widget.text,
          style: const TextStyle(fontSize: 16, color: Colors.black38, fontWeight: FontWeight.w500),
        )),
        Switch(value: value, onChanged: widget.onChanged)
      ],
    );
  }
}
