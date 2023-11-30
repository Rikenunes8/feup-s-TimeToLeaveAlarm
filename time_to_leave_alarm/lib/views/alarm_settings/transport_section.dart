import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_section.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_switch_tile.dart';
import 'package:time_to_leave_alarm/components/transportation_mean_card.dart';

enum TransportMean { driving, transit, walking, cycling }

class TransportSection extends StatefulWidget {
  final TransportController controller;

  const TransportSection({Key? key, required this.controller}) : super(key: key);

  @override
  State<TransportSection> createState() => _TransportSectionState();
}

class _TransportSectionState extends State<TransportSection> {
  TransportMean selectedMean = TransportMean.driving;

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
              selected: selectedMean == TransportMean.driving,
              callback: () => setState(() => selectedMean = TransportMean.driving)),
          TransportationMeanCard(
              icon: Icons.directions_transit,
              text: "Transit",
              selected: selectedMean == TransportMean.transit,
              callback: () => setState(() => selectedMean = TransportMean.transit)),
          TransportationMeanCard(
              icon: Icons.directions_walk,
              text: "Walking",
              selected: selectedMean == TransportMean.walking,
              callback: () => setState(() => selectedMean = TransportMean.walking)),
          TransportationMeanCard(
              icon: Icons.directions_bike,
              text: "Cycling",
              selected: selectedMean == TransportMean.cycling,
              callback: () => setState(() => selectedMean = TransportMean.cycling)),
        ],
      ),
      const AlarmSettingsSwitchTile(icon: Icons.currency_bitcoin, text: "Tolls"),
      const AlarmSettingsSwitchTile(icon: Icons.directions, text: "Highways"),
      const AlarmSettingsSwitchTile(icon: Icons.directions_ferry, text: "Ferries")
    ]);
  }
}

class TransportController {
  bool tolls = false;
  bool highways = false;
  bool ferries = false;
  TransportMean mean = TransportMean.driving;
}
