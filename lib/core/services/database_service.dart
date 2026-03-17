import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final dbFilePath = path.join(dbPath, 'arteria_fit.db');

    return await openDatabase(
      dbFilePath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE exercise_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exercise_type TEXT NOT NULL,
        completed_at TEXT NOT NULL,
        duration_seconds INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE daily_goals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exercise_type TEXT NOT NULL UNIQUE,
        goal INTEGER NOT NULL
      )
    ''');

    await db.insert('daily_goals', {'exercise_type': 'breathing', 'goal': 3});
    await db.insert('daily_goals', {'exercise_type': 'isometric', 'goal': 2});
  }

  Future<int> insertExerciseLog({
    required String exerciseType,
    required int durationSeconds,
  }) async {
    final db = await database;
    return await db.insert('exercise_log', {
      'exercise_type': exerciseType,
      'completed_at': DateTime.now().toIso8601String(),
      'duration_seconds': durationSeconds,
    });
  }

  Future<List<Map<String, dynamic>>> getLogsToday() async {
    final db = await database;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).toIso8601String();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String();

    return await db.query(
      'exercise_log',
      where: 'completed_at BETWEEN ? AND ?',
      whereArgs: [startOfDay, endOfDay],
    );
  }

  Future<int> getDailyGoal(String exerciseType) async {
    final db = await database;
    final result = await db.query(
      'daily_goals',
      where: 'exercise_type = ?',
      whereArgs: [exerciseType],
    );

    if (result.isNotEmpty) {
      return result.first['goal'] as int;
    }
    return 3;
  }

  Future<void> setDailyGoal(String exerciseType, int goal) async {
    final db = await database;
    await db.insert(
      'daily_goals',
      {'exercise_type': exerciseType, 'goal': goal},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getCompletedTodayCount(String exerciseType) async {
    final logs = await getLogsToday();
    return logs.where((log) => log['exercise_type'] == exerciseType).length;
  }

  Future<List<Map<String, dynamic>>> getAllLogs() async {
    final db = await database;
    return await db.query(
      'exercise_log',
      orderBy: 'completed_at DESC',
    );
  }
}
