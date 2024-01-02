import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/controllers/api/requests/coordinates_to_address.dart';
import 'package:time_to_leave_alarm/views/map_page.dart';

class MapLocationButton extends StatelessWidget {
  const MapLocationButton({super.key, required this.then, this.iconSize = 30});

  final Function(String) then;
  final double iconSize;

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
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: () => _onPressedMapButton(context),
        child: Icon(Icons.map, size: iconSize, color: Theme.of(context).primaryColor)
      )
    );
  }
}
