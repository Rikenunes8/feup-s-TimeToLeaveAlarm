import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:time_to_leave_alarm/models/alarm.dart';


class DatabaseManager {
  Database? _database;

  static const String databaseFilename = 'database.db';

  static const String alarmsTable = "Alarms";
  static const String idCol = "id";
  static const String nameCol = "name";
  static const String arriveTimeCol = "arrive_time";
  static const String leaveTimeCol = "leave_time";
  static const String modeCol = "mode";
  static const String originCol = "origin";
  static const String destinationCol = "destination";
  static const String periodCol = "period";
  static const String periodDataCol = "period_data";


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

    return openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await createAlarmsTable(db);
          await seedDatabase(db);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < newVersion) {
            await seedDatabase(db);
          }
        }
    );
  }

  createAlarmsTable(Database db) async {
    await db.execute(
      '''
      CREATE TABLE $alarmsTable (
        $idCol INTEGER PRIMARY KEY AUTOINCREMENT
        $nameCol TEXT,
        $arriveTimeCol TEXT,
        $leaveTimeCol TEXT,
        $modeCol TEXT,
        $originCol TEXT,
        $destinationCol TEXT,
        $periodCol TEXT,
        $periodDataCol TEXT,
      );
      '''
    );
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
    await db.update(
      alarmsTable,
      alarm.toMap(),
      where: '$idCol = ?',
      whereArgs: [alarm.id]
    );
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
    return List.generate(maps.length, (i) => Alarm.fromJson(maps[i]));
  }
}
