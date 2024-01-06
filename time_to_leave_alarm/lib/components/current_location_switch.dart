import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/controllers/api/integrations/permissions.dart';

class CurrentLocationSwitch extends StatelessWidget {
  final Function(bool) onChanged;
  final bool value;

  const CurrentLocationSwitch(
      {super.key, required this.value, required this.onChanged});

  Future<void> _onSwitch(bool newValue, BuildContext context) async {
    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) {
      onChanged(false);
      return;
    }
    onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children:[
        const Text("Use current location at departure", style: TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Switch(
          value: value, 
          onChanged: (value) => _onSwitch(value, context)
        )
      ]);
  }
}
