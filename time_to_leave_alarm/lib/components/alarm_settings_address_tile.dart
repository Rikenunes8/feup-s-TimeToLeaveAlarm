import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/components/map_location_button.dart';
import 'package:time_to_leave_alarm/components/my_location_button.dart';
import 'package:time_to_leave_alarm/controllers/api/widgets/auto_complete_text_field.dart';

class AlarmSettingsAddressTile extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool removable;
  final void Function()? onRemove;

  const AlarmSettingsAddressTile(
      {Key? key, this.hintText = "", required this.icon, required this.controller, this.removable = false, this.onRemove = null})
      : super(key: key);

  Widget _buildAddressTile(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 5),
        Expanded(child: AutoCompleteTextField(controller: controller, hintText: hintText))
      ]
    );
  }

  Widget _buildAdressButtons(BuildContext) {
    return Row(children: [
      MyLocationButton(then: (address) => {controller.text = address}, iconSize: 20),
      MapLocationButton(then: (address) => {controller.text = address}, iconSize: 20),
      if (removable)
        IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.clear),
        ),
    ],
    mainAxisAlignment: MainAxisAlignment.end
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAddressTile(context),
        _buildAdressButtons(context),
      ],
      
    );
  }
}
