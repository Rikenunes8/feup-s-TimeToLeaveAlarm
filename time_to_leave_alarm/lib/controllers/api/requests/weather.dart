import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:time_to_leave_alarm/controllers/api/secrets.dart';

import 'package:http/http.dart' as http;

Future<dynamic> getWeather(double lat, double lng) async {
  final queryParameters = {
    'lat': lat.toString(),
    'lon': lng.toString(),
    'appid': openWeatherAPIKey,
    'units': 'metric',
  };
  final uri = Uri.https("api.openweathermap.org", "/data/2.5/weather", queryParameters);
  debugPrint(uri.toString());
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    final weather = jsonDecode(response.body);
    debugPrint(weather.toString());
    return weather;
  } else {
    return null;
  }
}