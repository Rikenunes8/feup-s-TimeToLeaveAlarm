import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/controllers/api/integrations/permissions.dart';

class CurrentLocationSwitch extends StatelessWidget {
  final Function(bool) onChanged;
  final bool value;

  const CurrentLocationSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

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
      // spaceBetween
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: const Text("Use location at departure", style: TextStyle(fontSize: 16)),
            )
          ],
        ),
        Switch(
          value: value,
          onChanged: (value) => _onSwitch(value, context),
        ),
      ],
    );
  }
}
