import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:time_to_leave_alarm/controllers/api/requests/coordinates_to_address.dart';
import 'package:time_to_leave_alarm/controllers/api/integrations/permissions.dart';

class MyLocationButton extends StatelessWidget {
  const MyLocationButton({super.key, required this.then, this.iconSize = 30});

  final Function(String) then;
  final double iconSize;

  
  Future<void> _onPressedLocationButton(BuildContext context) async {
    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      convertCoordinatesToAddress(
          origin: LatLng(
            position.latitude,
            position.longitude,
          ),
          then: (address) => then(address));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: GestureDetector(
        onTap: () => _onPressedLocationButton(context),
        child: Icon(Icons.location_on,
            size: iconSize, color: Theme.of(context).primaryColor),
      ),
    );
  }
}
