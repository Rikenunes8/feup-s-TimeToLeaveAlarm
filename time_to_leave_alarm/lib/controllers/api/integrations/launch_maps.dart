import 'package:time_to_leave_alarm/models/alarm.dart';
import 'package:url_launcher/url_launcher.dart';

void launchAlarmNavigation(Alarm alarm) async {
  var uri = _buildUri(alarm);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch ${uri.toString()}';
  }
}

Uri _buildUri(Alarm alarm) {
  const String baseUrl = "https://www.google.com/maps/dir/?api=1";
  final String origin = alarm.origin != CURRENT_LOCATION_STRING
      ? "&origin=${alarm.origin}"
      : "";
  final String destination = "&destination=${alarm.destination}";
  final String waypoints =
      "&waypoints=${alarm.getIntermediateLocations().where((e) => e.isNotEmpty).join("|")}";

  const modeMap = {
    "drive": "driving",
    "transit": "transit",
    "walk": "walking",
    "bicycle": "bicycling"
  };
  final String travelMode = "&travelmode=${modeMap[alarm.mode]}";

  // NOTE: avoidTolls, avoidHighways, avoidFerries are not supported by this URL api
  // they are available using the Navigation API which opens the navigation mode,
  // yet, this mode won't work well as a DEMO since it always starts from the current location

  return Uri.parse(baseUrl + origin + destination + waypoints + travelMode);
}
