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

  Alarm(
      this.arriveTime,
      this.leaveTime,
      this.origin,
      this.destination,
      {this.id, this.name = '', this.mode = 'driving', this.period = '', this.periodData = '',}
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
      periodData: json["period_data"]
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
      "period_data": periodData
    };
  }

  @override
  bool operator==(Object other) {
    return id == (other as Alarm).id;
  }
}
