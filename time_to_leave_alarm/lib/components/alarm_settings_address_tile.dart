import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/components/map_location_button.dart';
import 'package:time_to_leave_alarm/components/my_location_button.dart';
import 'package:time_to_leave_alarm/controllers/api/widgets/auto_complete_text_field.dart';

class AlarmSettingsAddressTile extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final void Function()? onClear;

  const AlarmSettingsAddressTile(
      {super.key, this.hintText = "", required this.icon, required this.controller, this.onClear});

  Widget _buildAddressTile(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 5),
        Expanded(child: AutoCompleteTextField(controller: controller, hintText: hintText)),
        IconButton(onPressed: () => {controller.clear(), onClear!()}, icon: const Icon(Icons.clear)),
        MyLocationButton(then: (address) => {controller.text = address}, iconSize: 20),
        MapLocationButton(then: (address) => {controller.text = address}, iconSize: 20),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAddressTile(context),
      ],
      
    );
  }
}
