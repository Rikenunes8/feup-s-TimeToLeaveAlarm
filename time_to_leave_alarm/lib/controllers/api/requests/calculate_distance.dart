import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/controllers/api/secrets.dart';
import 'package:time_to_leave_alarm/controllers/api/requests/address_to_coordinates.dart';
import 'package:http/http.dart' as http;

calculateDistance(
    {required String origin,
    required String destination,
    required Function(int) then}) {
  if (googleDistanceAPIKey == '') {
    debugPrint('Google Distance API Key not configured. Using mock data');
    then(2342);
  } else {
    final uriParameters = {
      'key': googleDistanceAPIKey,
      'fields': 'routes.distanceMeters,routes.duration',
    };
    final queryParameters = {
      'destination': {
        'address': destination,
      },
      'origin': {
        'address': origin,
      },
      // 'intermediates': [
      //   {
      //     'location': {
      //       'address': 'Faculdade de Engenharia da Universidade do Porto',
      //     }
      //    'via': true/false
      //   }
      // ],

      'travelMode': 'DRIVE',
      'routeModifiers': {
        'avoidTolls': false,
        'avoidHighways': false,
        'avoidFerries': false
      },
      // "departureTime": "2023-10-15T15:01:23.045123456Z",
    };
    // final uri = Uri.https('maps.googleapis.com',
    //     '/maps/api/distancematrix/json', queryParameters);
    final uri = Uri.https(
        'routes.googleapis.com', '/directions/v2:computeRoutes', uriParameters);
    debugPrint(uri.toString());
    http.post(uri, body: jsonEncode(queryParameters)).then((value) {
      debugPrint(value.body);
      debugPrint(value.statusCode.toString());
      var json = jsonDecode(value.body);
      var time = json["routes"][0]["duration"];

      then(time);
    });
  }
}
