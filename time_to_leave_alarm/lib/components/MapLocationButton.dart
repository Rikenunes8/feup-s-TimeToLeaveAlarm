import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/controllers/api/requests/coordinates_to_address.dart';
import 'package:time_to_leave_alarm/views/map_page.dart';

class MapLocationButton extends StatelessWidget {
  const MapLocationButton({super.key, required this.then});

  final Function(String) then;

  Future<void> _onPressedMapButton(BuildContext context) async {
    final coordinates = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const MapPage(title: 'Select location')),
    );

    convertCoordinatesToAddress(
        origin: coordinates, then: (address) => then(address));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => _onPressedMapButton(context),
        child: const Icon(Icons.map));
  }
}
