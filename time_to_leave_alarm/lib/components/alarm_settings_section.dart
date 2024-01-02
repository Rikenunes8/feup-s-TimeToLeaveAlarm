import 'package:flutter/material.dart';

class AlarmSettingsSection extends StatefulWidget {
  const AlarmSettingsSection({Key? key, required this.sectionTitle, required this.children})
      : super(key: key);

  final String sectionTitle;
  final List<Widget> children;

  @override
  State<AlarmSettingsSection> createState() => _AlarmSettingsSectionState();
}

class _AlarmSettingsSectionState extends State<AlarmSettingsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: Text(widget.sectionTitle, style: const TextStyle(fontSize: 16),)),
        SizedBox(
          width: double.infinity,
          child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.children,
                ),
              )),
        )
      ],
    ),);
  }
}
