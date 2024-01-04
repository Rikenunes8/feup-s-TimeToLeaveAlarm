import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/controllers/api/secrets.dart';

import 'package:http/http.dart' as http;

getWeather(double lat, double lng, Function(Map<String, dynamic>) then) {
  final queryParameters = {
    'lat': lat.toString(),
    'lon': lng.toString(),
    'appid': openWeatherAPIKey,
    'units': 'metric',
  };
  final uri = Uri.https("api.openweathermap.org", "/data/2.5/weather", queryParameters);
  debugPrint(uri.toString());
  http.get(uri).then((value) {
    var json = jsonDecode(value.body);
    then(json);
  });
}