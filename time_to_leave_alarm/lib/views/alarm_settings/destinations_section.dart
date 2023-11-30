import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_address_tile.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_section.dart';

class DestinationsSection extends StatefulWidget {
  final DestinationsController controller;

  const DestinationsSection({Key? key, required this.controller}) : super(key: key);

  @override
  State<DestinationsSection> createState() => _DestinationsSectionState();
}

class _DestinationsSectionState extends State<DestinationsSection> {

  @override
  Widget build(BuildContext context) {
    return AlarmSettingsSection(sectionTitle: "Destinations", children: [
      AlarmSettingsAddressTile(icon: Icons.my_location, hintText: "From", controller: widget.controller.fromController,),
      AlarmSettingsAddressTile(icon: Icons.flag, hintText: "To", controller: widget.controller.toController,),
    ]);
  }
}

class DestinationsController {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  void dispose() {
    fromController.dispose();
    toController.dispose();
  }
}
