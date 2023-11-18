class Alarm {
  final String id;
  final String name;
  final String time;

  Alarm(this.id, this.name, this.time, );

  Alarm.fromJson(json) : this(
    json['id'],
    json['name'],
    json['time']
  );

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}