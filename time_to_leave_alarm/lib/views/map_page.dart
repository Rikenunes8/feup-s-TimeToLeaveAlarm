import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  static const route = '/map';

  const MapPage({super.key, required this.title});

  final String title;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(41.18, -8.60);
  LatLng? _selectedLocation;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: _selectedLocation != null
              ? {
                  Marker(
                    markerId:
                        MarkerId("Selected ${_selectedLocation.toString()}"),
                    position: _selectedLocation!,
                  )
                }
              : {},
          onTap: (LatLng latLng) {
            setState(() {
              _selectedLocation = latLng;
            });
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context, _selectedLocation);
          },
          child: const Icon(Icons.check),
        ));
  }
}
