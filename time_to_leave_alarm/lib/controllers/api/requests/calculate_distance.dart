import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/controllers/api/secrets.dart';
import 'package:http/http.dart' as http;


calculateDistance(
    {required String origin,
    required String destination,
    required Function(int) then,
    List<String> intermediateLocations = const [],
    travelMode = 'DRIVE',
    avoidTolls = false,
    avoidHighways = false,
    avoidFerries = false}) {
  if (googleDistanceAPIKey == '') {
    debugPrint('Google Distance API Key not configured. Using mock data');
    then(2342);
  } else {
    final uriParameters = {
      'key': googleDistanceAPIKey,
      'fields': 'routes.duration',
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
      'travelMode': travelMode,
      if (travelMode == 'DRIVE') 'routingPreference': 'TRAFFIC_AWARE',
      if (travelMode == 'DRIVE') 'routeModifiers': {
        'avoidTolls': avoidTolls,
        'avoidHighways': avoidHighways,
        'avoidFerries': avoidFerries
      },
      // "departureTime": "2023-10-15T15:01:23.045123456Z",
    };

    final uri = Uri.https(
        'routes.googleapis.com', '/directions/v2:computeRoutes', uriParameters);

    debugPrint(queryParameters.toString());

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
