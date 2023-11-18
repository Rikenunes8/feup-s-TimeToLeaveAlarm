class Alarm {
  final int? id;
  final String name;
  final String arriveTime;
  final String leaveTime;
  final String mode;
  final String origin;
  final String destination;
  final String period;
  final String periodData;
  bool turnedOn;

  Alarm(
      this.arriveTime,
      this.leaveTime,
      this.origin,
      this.destination,
      {this.id, this.name = '', this.mode = 'driving', this.period = '', this.periodData = '', this.turnedOn = true}
      );

  Alarm.fromMap(json) : this(
      json["arrive_time"],
      json["leave_time"],
      json["origin"],
      json["destination"],
      id: json["id"],
      name: json["name"],
      mode: json["mode"],
      period: json["period"],
      periodData: json["period_data"],
      turnedOn: json["turned_on"] == 0 ? false : true
  );

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
      "turned_on": turnedOn ? 1 : 0
    };
  }

  @override
  bool operator==(Object other) {
    return id == (other as Alarm).id;
  }
}
