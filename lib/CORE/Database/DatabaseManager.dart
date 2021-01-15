import 'package:hl_timer_app/CORE/DataModels/TimerModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  DatabaseManager._();

  static final DatabaseManager _instance = DatabaseManager._();

  static DatabaseManager get instance => _instance;

  Future<Database> timerDataBase;

  init() async {
    timerDataBase = openDatabase(
      join(await getDatabasesPath(), 'timer_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE timers(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, status INTEGER, timeLeft INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertTimer(TimerModel timerModel) async {
    var db = await timerDataBase;
    await db.insert(
      'timers',
      timerModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTimer(TimerModel timerModel) async {
    var db = await timerDataBase;
    await db.update(
      'timers',
      timerModel.toMap(),
      where: "id = ?",
      whereArgs: [timerModel.id],
    );
  }

  Future<List<TimerModel>> getAllTimers() async {
    var db = await timerDataBase;
    final List<Map<String, dynamic>> maps = await db.query('timers');
    return List.generate(maps.length, (i) {
      return TimerModel.fromDb(maps[i]);
    });
  }
}
