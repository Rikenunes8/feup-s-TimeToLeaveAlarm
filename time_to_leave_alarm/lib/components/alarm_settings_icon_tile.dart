import 'package:flutter/material.dart';

class AlarmSettingsIconTile extends StatelessWidget {
  final IconData icon;
  final Widget child;

  const AlarmSettingsIconTile({Key? key, required this.icon, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 5),
        Expanded(child: child),
      ],
    );
  }
}
