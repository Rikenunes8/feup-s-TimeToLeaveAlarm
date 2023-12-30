import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/controllers/api/secrets.dart';
import 'package:http/http.dart' as http;

calculateDistance(
    {required String origin,
    required String destination,
    required Function(int) then,
    List<String> intermediateLocations = const []}) {
  if (googleDistanceAPIKey == '') {
    debugPrint('Google Distance API Key not configured. Using mock data');
    then(2342);
  } else {
    final uriParameters = {
      'key': googleDistanceAPIKey,
      'fields': 'routes.distanceMeters,routes.duration',
    };

    var intermediates = intermediateLocations.map((e) {
      return {
        'address': e,
        'via': true,
      };
    }).toList();

    final queryParameters = {
      'destination': {
        'address': destination,
      },
      'origin': {
        'address': origin,
      },
      if (intermediateLocations.isNotEmpty) 'intermediates': intermediates,
      'travelMode': 'DRIVE',
      'routingPreference': 'TRAFFIC_AWARE',
      'routeModifiers': {
        'avoidTolls': false,
        'avoidHighways': false,
        'avoidFerries': false
      },
      // "departureTime": "2023-10-15T15:01:23.045123456Z",
    };

    final uri = Uri.https(
        'routes.googleapis.com', '/directions/v2:computeRoutes', uriParameters);

    http.post(uri, body: jsonEncode(queryParameters)).then((value) {
      debugPrint(value.body);
      debugPrint(value.statusCode.toString());

      var json = jsonDecode(value.body);
      var duration = json["routes"][0]["duration"];

      var durationAsInt = int.parse(duration.replaceAll('s', ''));

      then(durationAsInt);
    });
  }
}
