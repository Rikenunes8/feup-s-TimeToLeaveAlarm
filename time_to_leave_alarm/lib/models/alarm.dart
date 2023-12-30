class Alarm {
  final int? id;
  final String name;
  final String arriveTime;
  final String leaveTime;
  final String mode;
  final String origin;
  final String destination;
  final String intermediateLocation1;
  final String intermediateLocation2;
  final String intermediateLocation3;
  final String intermediateLocation4;
  final String intermediateLocation5;
  final String period;
  final String periodData;
  final int androidAlarmId;
  bool turnedOn;

  Alarm(this.arriveTime, this.leaveTime, this.origin, this.destination,
      {this.id,
      this.name = '',
      this.mode = 'driving',
      this.period = '',
      this.periodData = '',
      this.turnedOn = true,
      this.androidAlarmId = 0,
      this.intermediateLocation1 = '',
      this.intermediateLocation2 = '',
      this.intermediateLocation3 = '',
      this.intermediateLocation4 = '',
      this.intermediateLocation5 = ''});

  Alarm.fromMap(json)
      : this(json["arrive_time"], json["leave_time"], json["origin"],
            json["destination"],
            id: json["id"],
            name: json["name"],
            mode: json["mode"],
            period: json["period"],
            periodData: json["period_data"],
            androidAlarmId: json["android_alarm_id"],
            turnedOn: json["turned_on"] == 0 ? false : true,
            intermediateLocation1: json["intermediate_location_1"],
            intermediateLocation2: json["intermediate_location_2"],
            intermediateLocation3: json["intermediate_location_3"],
            intermediateLocation4: json["intermediate_location_4"],
            intermediateLocation5: json["intermediate_location_5"]);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "arrive_time": arriveTime,
      "leave_time": leaveTime,
      "mode": mode,
      "origin": origin,
      "destination": destination,
      "period": period,
      "period_data": periodData,
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

  countIntermediateLocations() { // This is beautiful
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
