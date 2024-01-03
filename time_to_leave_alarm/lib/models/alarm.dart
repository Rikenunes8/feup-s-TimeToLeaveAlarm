import 'dart:convert';
import 'dart:io';

class Alarm {
  int? id;
  String origin;
  String destination;
  String leaveTime;
  String arriveTime;
  bool period;
  String periodData;
  String mode;
  bool tolls;
  bool highways;
  bool ferries;
  String name;
  String ringtone;
  bool vibrate;
  bool snooze;
  bool turnedOn;
  int androidAlarmId;
  String intermediateLocation1;
  String intermediateLocation2;
  String intermediateLocation3;
  String intermediateLocation4;
  String intermediateLocation5;

  Alarm(
      {this.id,
      this.origin = '',
      this.destination = '',
      this.leaveTime = '',
      this.arriveTime = '',
      this.period = false,
      this.periodData = '',
      this.mode = 'driving',
      this.tolls = false,
      this.highways = false,
      this.ferries = false,
      this.name = '',
      this.ringtone = '',
      this.vibrate = false,
      this.snooze = false,
      this.turnedOn = true,
      this.androidAlarmId = 0,
      this.intermediateLocation1 = '',
      this.intermediateLocation2 = '',
      this.intermediateLocation3 = '',
      this.intermediateLocation4 = '',
      this.intermediateLocation5 = ''});

  Alarm.fromMap(json)
      : this(
            id: json["id"],
            origin: json["origin"],
            destination: json["destination"],
            leaveTime: json["leave_time"],
            arriveTime: json["arrive_time"],
            period: json["period"] == 0 ? false : true,
            periodData: json["period_data"],
            mode: json["mode"],
            tolls: json["tolls"] == 0 ? false : true,
            highways: json["highways"] == 0 ? false : true,
            ferries: json["ferries"] == 0 ? false : true,
            name: json["name"],
            ringtone: json["name"],
            vibrate: json["vibrate"] == 0 ? false : true,
            snooze: json["snooze"] == 0 ? false : true,
            turnedOn: json["turned_on"] == 0 ? false : true,
            androidAlarmId: json["android_alarm_id"],
            intermediateLocation1: json["intermediate_location_1"],
            intermediateLocation2: json["intermediate_location_2"],
            intermediateLocation3: json["intermediate_location_3"],
            intermediateLocation4: json["intermediate_location_4"],
            intermediateLocation5: json["intermediate_location_5"]);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "origin": origin,
      "destination": destination,
      "leave_time": leaveTime,
      "arrive_time": arriveTime,
      "period": period ? 1 : 0,
      "period_data": periodData,
      "mode": mode,
      "tolls": tolls ? 1 : 0,
      "highways": highways ? 1 : 0,
      "ferries": ferries ? 1 : 0,
      "name": name,
      "ringtone": ringtone,
      "vibrate": vibrate ? 1 : 0,
      "snooze": snooze ? 1 : 0,
      "turned_on": turnedOn ? 1 : 0,
      "android_alarm_id": androidAlarmId,
      "intermediate_location_1": intermediateLocation1,
      "intermediate_location_2": intermediateLocation2,
      "intermediate_location_3": intermediateLocation3,
      "intermediate_location_4": intermediateLocation4,
      "intermediate_location_5": intermediateLocation5,
    };
  }

  @override
  bool operator ==(Object other) {
    return id == (other as Alarm).id;
  }

  String toCode() {
    final json = utf8.encode(jsonEncode(toMap()));
    final zip = gzip.encode(json);
    final code = base64.encode(zip);
    return "ttl.alarm://$code/";
  }

  static Alarm? fromCode(String code) {
    try {
      code = code.substring(code.indexOf("ttl.alarm://") + 12);
      code = code.substring(0, code.length - 1);
      final zip = base64.decode(code);
      final json = gzip.decode(zip);
      final map = jsonDecode(utf8.decode(json));
      return Alarm.fromMap(map);
    } catch (e) {
      return null;
    }
  }

  countIntermediateLocations() {
    // This is beautiful
    var count = 0;
    if (intermediateLocation1.isNotEmpty) {
      count++;
    }
    if (intermediateLocation2.isNotEmpty) {
      count++;
    }
    if (intermediateLocation3.isNotEmpty) {
      count++;
    }
    if (intermediateLocation4.isNotEmpty) {
      count++;
    }
    if (intermediateLocation5.isNotEmpty) {
      count++;
    }
    return count;
  }

  List<String> getIntermediateLocations() {
    return [
      intermediateLocation1,
      intermediateLocation2,
      intermediateLocation3,
      intermediateLocation4,
      intermediateLocation5
    ];
  }
}
