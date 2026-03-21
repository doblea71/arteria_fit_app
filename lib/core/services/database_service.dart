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
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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

    await db.execute('''
      CREATE TABLE blood_pressure_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        systolic INTEGER NOT NULL,
        diastolic INTEGER NOT NULL,
        pulse INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        note TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE bp_protocol (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        start_date TEXT NOT NULL,
        morning_time TEXT NOT NULL,
        evening_time TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE bp_session (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        protocol_id INTEGER NOT NULL,
        day_number INTEGER NOT NULL,
        session_type TEXT NOT NULL,
        scheduled_at TEXT NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (protocol_id) REFERENCES bp_protocol(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE bp_reading (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        reading_index INTEGER NOT NULL,
        systolic INTEGER NOT NULL,
        diastolic INTEGER NOT NULL,
        pulse INTEGER,
        recorded_at TEXT NOT NULL,
        FOREIGN KEY (session_id) REFERENCES bp_session(id)
      )
    ''');

    await db.insert('daily_goals', {'exercise_type': 'breathing', 'goal': 3});
    await db.insert('daily_goals', {'exercise_type': 'isometric', 'goal': 2});
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE blood_pressure_log (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          systolic INTEGER NOT NULL,
          diastolic INTEGER NOT NULL,
          pulse INTEGER NOT NULL,
          created_at TEXT NOT NULL,
          note TEXT
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE bp_protocol (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          start_date TEXT NOT NULL,
          morning_time TEXT NOT NULL,
          evening_time TEXT NOT NULL,
          status TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE bp_session (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          protocol_id INTEGER NOT NULL,
          day_number INTEGER NOT NULL,
          session_type TEXT NOT NULL,
          scheduled_at TEXT NOT NULL,
          status TEXT NOT NULL,
          FOREIGN KEY (protocol_id) REFERENCES bp_protocol(id)
        )
      ''');
      await db.execute('''
        CREATE TABLE bp_reading (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          session_id INTEGER NOT NULL,
          reading_index INTEGER NOT NULL,
          systolic INTEGER NOT NULL,
          diastolic INTEGER NOT NULL,
          pulse INTEGER,
          recorded_at TEXT NOT NULL,
          FOREIGN KEY (session_id) REFERENCES bp_session(id)
        )
      ''');
    }
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

  Future<int> insertBloodPressure({
    required int systolic,
    required int diastolic,
    required int pulse,
    String? note,
  }) async {
    final db = await database;
    return await db.insert('blood_pressure_log', {
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'created_at': DateTime.now().toIso8601String(),
      'note': note,
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

  Future<List<Map<String, dynamic>>> getBloodPressureReadings() async {
    final db = await database;
    return await db.query(
      'blood_pressure_log',
      orderBy: 'created_at DESC',
    );
  }

  Future<Map<String, dynamic>?> getLastBloodPressureReading() async {
    final db = await database;
    final result = await db.query(
      'blood_pressure_log',
      orderBy: 'created_at DESC',
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
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

  Future<int> insertBpProtocol({
    required String startDate,
    required String morningTime,
    required String eveningTime,
    required String status,
  }) async {
    final db = await database;
    return await db.insert('bp_protocol', {
      'start_date': startDate,
      'morning_time': morningTime,
      'evening_time': eveningTime,
      'status': status,
    });
  }

  Future<Map<String, dynamic>?> getActiveBpProtocol() async {
    final db = await database;
    final result = await db.query(
      'bp_protocol',
      where: 'status = ?',
      whereArgs: ['active'],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> updateBpProtocolStatus(int id, String status) async {
    final db = await database;
    await db.update(
      'bp_protocol',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertBpSession({
    required int protocolId,
    required int dayNumber,
    required String sessionType,
    required String scheduledAt,
    required String status,
  }) async {
    final db = await database;
    return await db.insert('bp_session', {
      'protocol_id': protocolId,
      'day_number': dayNumber,
      'session_type': sessionType,
      'scheduled_at': scheduledAt,
      'status': status,
    });
  }

  Future<List<Map<String, dynamic>>> getBpSessionsByProtocol(int protocolId) async {
    final db = await database;
    return await db.query(
      'bp_session',
      where: 'protocol_id = ?',
      whereArgs: [protocolId],
      orderBy: 'scheduled_at ASC',
    );
  }

  Future<Map<String, dynamic>?> getBpSession(int id) async {
    final db = await database;
    final result = await db.query(
      'bp_session',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> updateBpSessionStatus(int id, String status) async {
    final db = await database;
    await db.update(
      'bp_session',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getBpSessionsWithReadings(int protocolId) async {
    final db = await database;
    final sessions = await db.query(
      'bp_session',
      where: 'protocol_id = ?',
      whereArgs: [protocolId],
      orderBy: 'scheduled_at ASC',
    );

    final results = <Map<String, dynamic>>[];

    for (final sessionData in sessions) {
      final session = Map<String, dynamic>.from(sessionData);
      final readings = await db.query(
        'bp_reading',
        where: 'session_id = ?',
        whereArgs: [session['id']],
        orderBy: 'reading_index ASC',
      );
      session['readings'] = readings;
      results.add(session);
    }
    return results;
  }

  Future<int> insertBpReading({
    required int sessionId,
    required int readingIndex,
    required int systolic,
    required int diastolic,
    int? pulse,
  }) async {
    final db = await database;
    return await db.insert('bp_reading', {
      'session_id': sessionId,
      'reading_index': readingIndex,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'recorded_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getBpReadingsBySession(int sessionId) async {
    final db = await database;
    return await db.query(
      'bp_reading',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'reading_index ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllBpReadingsForProtocol(int protocolId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT r.* FROM bp_reading r
      INNER JOIN bp_session s ON r.session_id = s.id
      WHERE s.protocol_id = ?
      ORDER BY r.recorded_at ASC
    ''', [protocolId]);
  }
}
