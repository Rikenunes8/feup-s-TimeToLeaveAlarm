import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_address_tile.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_section.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';

class DestinationsSection extends StatelessWidget {
  final DestinationsController controller;

  const DestinationsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlarmSettingsSection(sectionTitle: "Destinations", children: [
      AlarmSettingsAddressTile(
        icon: Icons.my_location,
        hintText: "From",
        controller: controller.fromController,
      ),
      for (final controller in controller.intermediateControllers)
        AlarmSettingsAddressTile(
          icon: Icons.circle_outlined,
          hintText: "Add intermediate...",
          controller: controller,
        ),
      AlarmSettingsAddressTile(
        icon: Icons.flag,
        hintText: "To",
        controller: controller.toController,
      ),
    ]);
  }
}

class DestinationsController {
  final List<TextEditingController> intermediateControllers = [];
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final int maxIntermediateLocations;
  VoidCallback onChange = () {};

  DestinationsController({this.maxIntermediateLocations = 5});

  void setOnChange(VoidCallback onChange) {
    this.onChange = onChange;
    fromController.addListener(onChange);
    toController.addListener(onChange);
    for (final controller in intermediateControllers) {
      controller.addListener(onChange);
    }
  }

  void addIntermediateController() {
    var controller = TextEditingController();
    controller.addListener(onChange);
    intermediateControllers.add(controller);
  }

  void removeIntermediateController(TextEditingController controller) {
    intermediateControllers.remove(controller);
  }

  void updateControllers() {
    if (intermediateControllers.isEmpty && fromController.text.isNotEmpty) {
      addIntermediateController();
      return;
    }
    for (var i = intermediateControllers.length - 1; i >= 0; i--) {
      var current = intermediateControllers[i];
      var previous = i == 0 ? fromController : intermediateControllers[i - 1];
      if (current.text.isEmpty && previous.text.isEmpty) {
        removeIntermediateController(current);
      } else {
        if (current.text.isNotEmpty &&
            intermediateControllers.length < maxIntermediateLocations) {
          addIntermediateController();
        }
        break;
      }
    }
  }

  void dispose() {
    fromController.dispose();
    for (final controller in intermediateControllers) {
      controller.dispose();
    }
    toController.dispose();
  }

  loadAlarm(Alarm alarm) {
    fromController.text = alarm.origin;
    toController.text = alarm.destination;
    intermediateControllers.clear();
    for (final intermediateLocation in alarm.getIntermediateLocations()) {
      if (intermediateLocation.isNotEmpty) {
        intermediateControllers
            .add(TextEditingController(text: intermediateLocation));
      }
    }
  }

  void setAlarm(Alarm alarm) {
    alarm.origin = fromController.text;
    alarm.destination = toController.text;

    getIntermediateLocation(int i) {
      if (i < intermediateControllers.length && intermediateControllers[i].text.isNotEmpty) {
        return intermediateControllers[i].text.toString();
      } else {
        return '';
      }
    }

    alarm.intermediateLocation1 = getIntermediateLocation(0);
    alarm.intermediateLocation2 = getIntermediateLocation(1);
    alarm.intermediateLocation3 = getIntermediateLocation(2);
    alarm.intermediateLocation4 = getIntermediateLocation(3);
    alarm.intermediateLocation5 = getIntermediateLocation(4);
  }
}
