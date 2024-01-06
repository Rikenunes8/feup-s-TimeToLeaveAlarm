import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:time_to_leave_alarm/controllers/api/secrets.dart';
import 'package:http/http.dart' as http;

convertCoordinatesToAddress(
    {required LatLng origin, required Function(String) then}) {
  if (googleDistanceAPIKey == '') {
    debugPrint('Google Distance API Key not configured. Using mock data');
    then("Mock Address");
  } else {
    final queryParameters = {
      'latlng': '${origin.latitude},${origin.longitude}',
      'key': googleDistanceAPIKey,
    };
    final uri = Uri.https(
        'maps.googleapis.com', '/maps/api/geocode/json', queryParameters);
    debugPrint(uri.toString());
    http.get(uri).then((value) {
      debugPrint(value.body);
      debugPrint(value.statusCode.toString());
      var json = jsonDecode(value.body);
      var address = json["results"][0]["formatted_address"];
      print(address);
      then(address);
    });
  }
}

Future<List<double>?> convertAddressToCoordinates(
    {required String address}) async {
  if (googleDistanceAPIKey == '') {
    debugPrint('Google Distance API Key not configured. Using mock data');
    return null;
  } else {
    final queryParameters = {
      'address': address,
      'key': googleDistanceAPIKey,
    };
    final uri = Uri.https(
        'maps.googleapis.com', '/maps/api/geocode/json', queryParameters);
    debugPrint(uri.toString());
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var lat = json["results"][0]["geometry"]["location"]["lat"];
      var lng = json["results"][0]["geometry"]["location"]["lng"];
      return [lat, lng];
    } else {
      return null;
    }
  }
}
