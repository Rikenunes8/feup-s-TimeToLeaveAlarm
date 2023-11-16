import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/controllers/api/secrets.dart';
import 'package:http/http.dart' as http;

calculateDistance({
  required String origin, 
  required String destination,
  required Function(int) then
}) {
  if (googleDistanceAPIKey == '') {
    debugPrint('Google Distance API Key not configured. Using mock data');
    then(2342);
  } else {
    final queryParameters = {
      'destinations': destination,
      'origins': origin,
      'mode': 'driving',
      'key': googleDistanceAPIKey,
    };
    final uri = Uri.https('maps.googleapis.com',
        '/maps/api/distancematrix/json', queryParameters);
    debugPrint(uri.toString());
    http.get(uri).then((value) {
      debugPrint(value.body);
      debugPrint(value.statusCode.toString());
      var json = jsonDecode(value.body);
      var element = json["rows"][0]["elements"][0];
      var time = element["duration_in_traffic"]["value"];
      then(time);
    });
  }
}
