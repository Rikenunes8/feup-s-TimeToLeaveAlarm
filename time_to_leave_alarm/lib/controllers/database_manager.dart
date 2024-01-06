import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';

class DatabaseManager {
  Database? _database;

  static const String databaseFilename = 'database.db';

  static const String alarmsTable = "Alarms";
  static const String idCol = "id";
  static const String arriveTimeCol = "arrive_time";
  static const String leaveTimeCol = "leave_time";
  static const String originCol = "origin";
  static const String destinationCol = "destination";
  static const String intermediateLocationCol1 = "intermediate_location_1";
  static const String intermediateLocationCol2 = "intermediate_location_2";
  static const String intermediateLocationCol3 = "intermediate_location_3";
  static const String intermediateLocationCol4 = "intermediate_location_4";
  static const String intermediateLocationCol5 = "intermediate_location_5";
  static const String anticipationCol = "anticipation";
  static const String periodCol = "period";
  static const String periodDataCol = "period_data";
  static const String modeCol = "mode";
  static const String tollsCol = "tolls";
  static const String highwaysCol = "highways";
  static const String ferriesCol = "ferries";
  static const String nameCol = "name";
  static const String ringtoneCol = "ringtone";
  static const String vibrateCol = "vibrate";
  // static const String snoozeCol = "snooze";
  static const String turnedOnCol = "turned_on";
  static const String androidAlarmIdCol = "android_alarm_id";
  static const String recalculateAndroidAlarmIdCol = "recalculate_android_alarm_id";

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, databaseFilename);

    return openDatabase(path, version: 3, onCreate: (db, version) async {
      await createAlarmsTable(db);
      await seedDatabase(db);
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < newVersion) {
        await seedDatabase(db);
      }
    });
  }

  createAlarmsTable(Database db) async { // TODO: Add a table for locations that has many to one relationship with alarms
    await db.execute('''
      CREATE TABLE $alarmsTable (
        $idCol INTEGER PRIMARY KEY AUTOINCREMENT,
        $originCol TEXT,
        $destinationCol TEXT,
        $intermediateLocationCol1 TEXT,
        $intermediateLocationCol2 TEXT,
        $intermediateLocationCol3 TEXT,
        $intermediateLocationCol4 TEXT,
        $intermediateLocationCol5 TEXT,
        $leaveTimeCol TEXT,
        $arriveTimeCol TEXT,
        $anticipationCol Integer,
        $periodCol INTEGER,
        $periodDataCol TEXT,
        $modeCol TEXT,
        $tollsCol INTEGER,
        $highwaysCol INTEGER,
        $ferriesCol INTEGER,
        $nameCol TEXT,
        $ringtoneCol TEXT,
        $vibrateCol INTEGER,
        $turnedOnCol INTEGER,
        $androidAlarmIdCol INTEGER,
        $recalculateAndroidAlarmIdCol INTEGER
      );
      ''');
  }

  seedDatabase(Database db) {}

  Future<void> insertAlarm(Alarm alarm) async {
    final db = await database;
    await db.insert(
      alarmsTable,
      alarm.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateAlarm(Alarm alarm) async {
    final db = await database;
    await db.update(alarmsTable, alarm.toMap(), where: '$idCol = ?', whereArgs: [alarm.id]);
  }

  Future<void> deleteAlarm(int id) async {
    final db = await database;
    await db.delete(
      alarmsTable,
      where: '$idCol = ?',
      whereArgs: [id],
    );
  }

  Future<List<Alarm>> getAlarms() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(alarmsTable);
    return List.generate(maps.length, (i) => Alarm.fromMap(maps[i]));
  }
}
