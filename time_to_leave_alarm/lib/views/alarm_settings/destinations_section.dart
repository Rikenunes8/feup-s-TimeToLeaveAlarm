import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_address_tile.dart';
import 'package:time_to_leave_alarm/components/alarm_settings_section.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';


class AddIntermediateLocationButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onPressed;

  const AddIntermediateLocationButton(
      {super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(onPressed: onPressed, icon: Icon(icon)),
      const SizedBox(width: 5),
      const Text("Add intermediate location"),
    ]);
  }
}

class DestinationsSection extends StatefulWidget {
  final DestinationsController controller;

  const DestinationsSection({Key? key, required this.controller})
      : super(key: key);

  @override
  State<DestinationsSection> createState() => _DestinationsSectionState();
}

class _DestinationsSectionState extends State<DestinationsSection> {
  addIntermediateLocation() {
    if (!canAddIntermediateLocationButton()) {
      // Show snackbar with message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Please fill in all fields before adding a new intermediate location')));
      return;
    }

    final intermediateController = TextEditingController();
    widget.controller.intermediateControllers.add(intermediateController);

    setState(() {});
  }

  removeIntermediateLocation(TextEditingController controller) {
    widget.controller.intermediateControllers.remove(controller);
    controller.dispose();
    setState(() {});
  }

  bool anyIntermediateLocationIsEmpty() {
    for (final controller in widget.controller.intermediateControllers) {
      if (controller.text.isEmpty) {
        return true;
      }
    }
    return false;
  }

  canAddIntermediateLocationButton() {
    return (widget.controller.intermediateControllers.length <= 5 &&
        widget.controller.toController.text.isNotEmpty &&
        widget.controller.fromController.text.isNotEmpty &&
        !anyIntermediateLocationIsEmpty());
  }

  @override
  Widget build(BuildContext context) {
    return AlarmSettingsSection(sectionTitle: "Destinations", children: [
      AlarmSettingsAddressTile(
        icon: Icons.my_location,
        hintText: "From",
        controller: widget.controller.fromController,
      ),
      for (final controller in widget.controller.intermediateControllers)
        AlarmSettingsAddressTile(
          icon: Icons.circle_outlined,
          hintText: "Intermediate",
          controller: controller,
          removable: true,
          onRemove: () => removeIntermediateLocation(controller),
        ),
      AlarmSettingsAddressTile(
        icon: Icons.flag,
        hintText: "To",
        controller: widget.controller.toController,
      ),
      AddIntermediateLocationButton(
          icon: Icons.add_circle_outline, onPressed: addIntermediateLocation)
    ]);
  }
}

class DestinationsController {
  final List<TextEditingController> intermediateControllers = [];
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

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
        intermediateControllers.add(TextEditingController(text: intermediateLocation));
      }
    }
  }
}
