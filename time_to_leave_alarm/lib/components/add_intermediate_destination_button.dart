import 'package:flutter/material.dart';

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