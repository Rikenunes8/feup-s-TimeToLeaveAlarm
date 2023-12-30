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
      this.androidAlarmId = 0});

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
            androidAlarmId: json["android_alarm_id"]);

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
      "android_alarm_id": androidAlarmId
    };
  }

  @override
  bool operator ==(Object other) {
    return id == (other as Alarm).id;
  }
}
