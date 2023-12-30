import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_section.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_switch_tile.dart';
import 'package:time_to_leave_alarm/components/transportation_mean_card.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';

enum TransportMean { driving, transit, walking, cycling }

extension ParseToString on TransportMean {
  String toShortString() {
    return toString().split('.').last;
  }
}

class TransportSection extends StatefulWidget {
  final TransportController controller;

  const TransportSection({Key? key, required this.controller}) : super(key: key);

  @override
  State<TransportSection> createState() => _TransportSectionState();
}

class _TransportSectionState extends State<TransportSection> {
  @override
  Widget build(BuildContext context) {
    return AlarmSettingsSection(sectionTitle: "Transport", children: [
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TransportationMeanCard(
              icon: Icons.directions_car,
              text: "Driving",
              selected: widget.controller.mean == TransportMean.driving,
              callback: () => setState(() => widget.controller.mean = TransportMean.driving)),
          TransportationMeanCard(
              icon: Icons.directions_transit,
              text: "Transit",
              selected: widget.controller.mean == TransportMean.transit,
              callback: () => setState(() => widget.controller.mean = TransportMean.transit)),
          TransportationMeanCard(
              icon: Icons.directions_walk,
              text: "Walking",
              selected: widget.controller.mean == TransportMean.walking,
              callback: () => setState(() => widget.controller.mean = TransportMean.walking)),
          TransportationMeanCard(
              icon: Icons.directions_bike,
              text: "Cycling",
              selected: widget.controller.mean == TransportMean.cycling,
              callback: () => setState(() => widget.controller.mean = TransportMean.cycling)),
        ],
      ),
      AlarmSettingsSwitchTile(
        icon: Icons.currency_bitcoin,
        text: "Tolls",
        initial: widget.controller.tolls,
        onChanged: (v) {
          setState(() {
            widget.controller.tolls = v;
          });
        },
      ),
      AlarmSettingsSwitchTile(
        icon: Icons.directions,
        text: "Highways",
        initial: widget.controller.highways,
        onChanged: (v) {
          setState(() {
            widget.controller.highways = v;
          });
        },
      ),
      AlarmSettingsSwitchTile(
          icon: Icons.directions_ferry,
          text: "Ferries",
          initial: widget.controller.ferries,
          onChanged: (v) {
            setState(() {
              widget.controller.ferries = v;
            });
          }),
    ]);
  }
}

class TransportController {
  bool tolls = false;
  bool highways = false;
  bool ferries = false;
  TransportMean mean = TransportMean.driving;

  void loadAlarm(Alarm alarm) {
    mean = TransportMean.values.firstWhere((e) => e.toString() == 'TransportMean.${alarm.mode}');
    tolls = alarm.tolls;
    highways = alarm.highways;
    ferries = alarm.ferries;
  }

  void setAlarm(Alarm alarm) {
    alarm.tolls = tolls;
    alarm.highways = highways;
    alarm.ferries = ferries;
    alarm.mode = mean.toShortString();
  }
}
