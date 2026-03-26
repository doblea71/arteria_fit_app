import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;
  static SharedPreferences? _prefs;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError('Use WebStorage for web platform');
    }
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<SharedPreferences> get webPrefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<bool> get isWeb async => kIsWeb;

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
    if (kIsWeb) {
      return await _webInsertExerciseLog(exerciseType, durationSeconds);
    }
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
    if (kIsWeb) {
      return await _webInsertBloodPressure(systolic, diastolic, pulse, note);
    }
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
    if (kIsWeb) {
      return await _webGetLogsToday();
    }
    final db = await database;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).toIso8601String();
    final endOfDay = DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
    ).toIso8601String();

    return await db.query(
      'exercise_log',
      where: 'completed_at BETWEEN ? AND ?',
      whereArgs: [startOfDay, endOfDay],
    );
  }

  Future<List<Map<String, dynamic>>> getBloodPressureReadings() async {
    if (kIsWeb) {
      return await _webGetBloodPressureReadings();
    }
    final db = await database;
    return await db.query('blood_pressure_log', orderBy: 'created_at DESC');
  }

  Future<Map<String, dynamic>?> getLastBloodPressureReading() async {
    if (kIsWeb) {
      return await _webGetLastBloodPressureReading();
    }
    final db = await database;
    final result = await db.query(
      'blood_pressure_log',
      orderBy: 'created_at DESC',
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> getDailyGoal(String exerciseType) async {
    if (kIsWeb) {
      return await _webGetDailyGoal(exerciseType);
    }
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
    if (kIsWeb) {
      await _webSetDailyGoal(exerciseType, goal);
      return;
    }
    final db = await database;
    await db.insert('daily_goals', {
      'exercise_type': exerciseType,
      'goal': goal,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> getCompletedTodayCount(String exerciseType) async {
    final logs = await getLogsToday();
    return logs.where((log) => log['exercise_type'] == exerciseType).length;
  }

  Future<List<Map<String, dynamic>>> getAllLogs() async {
    if (kIsWeb) {
      return await _webGetAllLogs();
    }
    final db = await database;
    return await db.query('exercise_log', orderBy: 'completed_at DESC');
  }

  Future<int> insertBpProtocol({
    required String startDate,
    required String morningTime,
    required String eveningTime,
    required String status,
  }) async {
    if (kIsWeb) {
      return await _webInsertBpProtocol(
        startDate,
        morningTime,
        eveningTime,
        status,
      );
    }
    final db = await database;
    return await db.insert('bp_protocol', {
      'start_date': startDate,
      'morning_time': morningTime,
      'evening_time': eveningTime,
      'status': status,
    });
  }

  Future<Map<String, dynamic>?> getActiveBpProtocol() async {
    if (kIsWeb) {
      return await _webGetActiveBpProtocol();
    }
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
    if (kIsWeb) {
      await _webUpdateBpProtocolStatus(id, status);
      return;
    }
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
    if (kIsWeb) {
      return await _webInsertBpSession(
        protocolId,
        dayNumber,
        sessionType,
        scheduledAt,
        status,
      );
    }
    final db = await database;
    return await db.insert('bp_session', {
      'protocol_id': protocolId,
      'day_number': dayNumber,
      'session_type': sessionType,
      'scheduled_at': scheduledAt,
      'status': status,
    });
  }

  Future<List<Map<String, dynamic>>> getBpSessionsByProtocol(
    int protocolId,
  ) async {
    if (kIsWeb) {
      return await _webGetBpSessionsByProtocol(protocolId);
    }
    final db = await database;
    return await db.query(
      'bp_session',
      where: 'protocol_id = ?',
      whereArgs: [protocolId],
      orderBy: 'scheduled_at ASC',
    );
  }

  Future<Map<String, dynamic>?> getBpSession(int id) async {
    if (kIsWeb) {
      return await _webGetBpSession(id);
    }
    final db = await database;
    final result = await db.query(
      'bp_session',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> updateBpSessionStatus(int id, String status) async {
    if (kIsWeb) {
      await _webUpdateBpSessionStatus(id, status);
      return;
    }
    final db = await database;
    await db.update(
      'bp_session',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getBpSessionsWithReadings(
    int protocolId,
  ) async {
    if (kIsWeb) {
      return await _webGetBpSessionsWithReadings(protocolId);
    }
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
    if (kIsWeb) {
      return await _webInsertBpReading(
        sessionId,
        readingIndex,
        systolic,
        diastolic,
        pulse,
      );
    }
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

  Future<List<Map<String, dynamic>>> getBpReadingsBySession(
    int sessionId,
  ) async {
    if (kIsWeb) {
      return await _webGetBpReadingsBySession(sessionId);
    }
    final db = await database;
    return await db.query(
      'bp_reading',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'reading_index ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllBpReadingsForProtocol(
    int protocolId,
  ) async {
    if (kIsWeb) {
      return await _webGetAllBpReadingsForProtocol(protocolId);
    }
    final db = await database;
    return await db.rawQuery(
      '''
      SELECT r.* FROM bp_reading r
      INNER JOIN bp_session s ON r.session_id = s.id
      WHERE s.protocol_id = ?
      ORDER BY r.recorded_at ASC
    ''',
      [protocolId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllBpProtocols() async {
    if (kIsWeb) {
      return await _webGetAllBpProtocols();
    }
    final db = await database;
    return await db.query('bp_protocol', orderBy: 'start_date DESC');
  }

  // Web Storage Implementation using SharedPreferences
  static const String _keyExerciseLog = 'web_exercise_log';
  static const String _keyBloodPressureLog = 'web_blood_pressure_log';
  static const String _keyDailyGoals = 'web_daily_goals';
  static const String _keyBpProtocols = 'web_bp_protocols';
  static const String _keyBpSessions = 'web_bp_sessions';
  static const String _keyBpReadings = 'web_bp_readings';

  int _getNextId(List<Map<String, dynamic>> items) {
    if (items.isEmpty) return 1;
    final maxId = items
        .map((e) => e['id'] as int? ?? 0)
        .reduce((a, b) => a > b ? a : b);
    return maxId + 1;
  }

  Future<int> _webInsertExerciseLog(
    String exerciseType,
    int durationSeconds,
  ) async {
    final prefs = await webPrefs;
    final data = prefs.getString(_keyExerciseLog);
    final items = data != null
        ? (jsonDecode(data) as List)
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
        : <Map<String, dynamic>>[];
    final id = _getNextId(items);
    items.add({
      'id': id,
      'exercise_type': exerciseType,
      'completed_at': DateTime.now().toIso8601String(),
      'duration_seconds': durationSeconds,
    });
    await prefs.setString(_keyExerciseLog, jsonEncode(items));
    return id;
  }

  Future<int> _webInsertBloodPressure(
    int systolic,
    int diastolic,
    int pulse,
    String? note,
  ) async {
    final prefs = await webPrefs;
    final data = prefs.getString(_keyBloodPressureLog);
    final items = data != null
        ? (jsonDecode(data) as List)
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
        : <Map<String, dynamic>>[];
    final id = _getNextId(items);
    items.add({
      'id': id,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'created_at': DateTime.now().toIso8601String(),
      'note': note,
    });
    await prefs.setString(_keyBloodPressureLog, jsonEncode(items));
    return id;
  }

  Future<List<Map<String, dynamic>>> _webGetLogsToday() async {
    final prefs = await webPrefs;
    final data = prefs.getString(_keyExerciseLog);
    if (data == null) return [];
    final items = (jsonDecode(data) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return items.where((item) {
      final completedAt = DateTime.tryParse(item['completed_at'] ?? '');
      return completedAt != null && completedAt.isAfter(startOfDay);
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _webGetBloodPressureReadings() async {
    final prefs = await webPrefs;
    final data = prefs.getString(_keyBloodPressureLog);
    if (data == null) return [];
    final items = (jsonDecode(data) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    items.sort(
      (a, b) =>
          (b['created_at'] as String).compareTo(a['created_at'] as String),
    );
    return items;
  }

  Future<Map<String, dynamic>?> _webGetLastBloodPressureReading() async {
    final readings = await _webGetBloodPressureReadings();
    return readings.isNotEmpty ? readings.first : null;
  }

  Future<int> _webGetDailyGoal(String exerciseType) async {
    final prefs = await webPrefs;
    final data = prefs.getString(_keyDailyGoals);
    if (data == null) return 3;
    final items = (jsonDecode(data) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    final goal = items
        .where((item) => item['exercise_type'] == exerciseType)
        .firstOrNull;
    return goal?['goal'] as int? ?? 3;
  }

  Future<void> _webSetDailyGoal(String exerciseType, int goal) async {
    final prefs = await webPrefs;
    final data = prefs.getString(_keyDailyGoals);
    final items = data != null
        ? (jsonDecode(data) as List)
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
        : <Map<String, dynamic>>[];
    items.removeWhere((item) => item['exercise_type'] == exerciseType);
    items.add({'exercise_type': exerciseType, 'goal': goal});
    await prefs.setString(_keyDailyGoals, jsonEncode(items));
  }

  Future<List<Map<String, dynamic>>> _webGetAllLogs() async {
    final prefs = await webPrefs;
    final data = prefs.getString(_keyExerciseLog);
    if (data == null) return [];
    final items = (jsonDecode(data) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    items.sort(
      (a, b) =>
          (b['completed_at'] as String).compareTo(a['completed_at'] as String),
    );
    return items;
  }

  Future<int> _webInsertBpProtocol(
    String startDate,
    String morningTime,
    String eveningTime,
    String status,
  ) async {
    final prefs = await webPrefs;
    final data = prefs.getString(_keyBpProtocols);
    final items = data != null
        ? (jsonDecode(data) as List)
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
        : <Map<String, dynamic>>[];
    final id = _getNextId(items);
    items.add({
      'id': id,
      'start_date': startDate,
      'morning_time': morningTime,
      'evening_time': eveningTime,
      'status': status,
    });
    await prefs.setString(_keyBpProtocols, jsonEncode(items));
    return id;
  }

  Future<Map<String, dynamic>?> _webGetActiveBpProtocol() async {
    final prefs = await webPrefs;
    final data = prefs.getString(_keyBpProtocols);
    if (data == null) return null;
    final items = (jsonDecode(data) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    return items.where((item) => item['status'] == 'active').firstOrNull;
  }

  Future<void> _webUpdateBpProtocolStatus(int id, String status) async {
    final prefs = await webPrefs;
    final data = prefs.getString(_keyBpProtocols);
    if (data == null) return;
    final items = (jsonDecode(data) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    final index = items.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      items[index]['status'] = status;
      await prefs.setString(_keyBpProtocols, jsonEncode(items));
    }
  }

  Future<int> _webInsertBpSession(
    int protocolId,
    int dayNumber,
    String sessionType,
    String scheduledAt,
    String status,
  ) async {
    final prefs = await webPrefs;
    final data = prefs.getString(_keyBpSessions);
    final items = data != null
        ? (jsonDecode(data) as List)
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
        : <Map<String, dynamic>>[];
    final id = _getNextId(items);
    items.add({
      'id': id,
      'protocol_id': protocolId,
      'day_number': dayNumber,
      'session_type': sessionType,
      'scheduled_at': scheduledAt,
      'status': status,
    });
    await prefs.setString(_keyBpSessions, jsonEncode(items));
    return id;
  }

  Future<List<Map<String, dynamic>>> _webGetBpSessionsByProtocol(
    int protocolId,
  ) async {
    final prefs = await webPrefs;
    final data = prefs.getString(_keyBpSessions);
    if (data == null) return [];
    final items = (jsonDecode(data) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    items.sort(
      (a, b) =>
          (a['scheduled_at'] as String).compareTo(b['scheduled_at'] as String),
    );
    return items.where((item) => item['protocol_id'] == protocolId).toList();
  }

  Future<Map<String, dynamic>?> _webGetBpSession(int id) async {
    final prefs = await webPrefs;
    final data = prefs.getString(_keyBpSessions);
    if (data == null) return null;
    final items = (jsonDecode(data) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    return items.where((item) => item['id'] == id).firstOrNull;
  }

  Future<void> _webUpdateBpSessionStatus(int id, String status) async {
    final prefs = await webPrefs;
    final data = prefs.getString(_keyBpSessions);
    if (data == null) return;
    final items = (jsonDecode(data) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    final index = items.indexWhere((item) => item['id'] == id);
    if (index >= 0) {
      items[index]['status'] = status;
      await prefs.setString(_keyBpSessions, jsonEncode(items));
    }
  }

  Future<List<Map<String, dynamic>>> _webGetBpSessionsWithReadings(
    int protocolId,
  ) async {
    final sessions = await _webGetBpSessionsByProtocol(protocolId);
    final results = <Map<String, dynamic>>[];
    final prefs = await webPrefs;
    final readingsData = prefs.getString(_keyBpReadings);
    final allReadings = readingsData != null
        ? (jsonDecode(readingsData) as List)
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
        : <Map<String, dynamic>>[];

    for (final session in sessions) {
      final sessionMap = Map<String, dynamic>.from(session);
      final readings = allReadings
          .where((r) => r['session_id'] == session['id'])
          .toList();
      readings.sort(
        (a, b) =>
            (a['reading_index'] as int).compareTo(b['reading_index'] as int),
      );
      sessionMap['readings'] = readings;
      results.add(sessionMap);
    }
    return results;
  }

  Future<int> _webInsertBpReading(
    int sessionId,
    int readingIndex,
    int systolic,
    int diastolic,
    int? pulse,
  ) async {
    final prefs = await webPrefs;
    final data = prefs.getString(_keyBpReadings);
    final items = data != null
        ? (jsonDecode(data) as List)
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
        : <Map<String, dynamic>>[];
    final id = _getNextId(items);
    items.add({
      'id': id,
      'session_id': sessionId,
      'reading_index': readingIndex,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'recorded_at': DateTime.now().toIso8601String(),
    });
    await prefs.setString(_keyBpReadings, jsonEncode(items));
    return id;
  }

  Future<List<Map<String, dynamic>>> _webGetBpReadingsBySession(
    int sessionId,
  ) async {
    final prefs = await webPrefs;
    final data = prefs.getString(_keyBpReadings);
    if (data == null) return [];
    final items = (jsonDecode(data) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    items.sort(
      (a, b) =>
          (a['reading_index'] as int).compareTo(b['reading_index'] as int),
    );
    return items.where((item) => item['session_id'] == sessionId).toList();
  }

  Future<List<Map<String, dynamic>>> _webGetAllBpReadingsForProtocol(
    int protocolId,
  ) async {
    final sessions = await _webGetBpSessionsByProtocol(protocolId);
    final prefs = await webPrefs;
    final data = prefs.getString(_keyBpReadings);
    if (data == null) return [];
    final allReadings = (jsonDecode(data) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    final sessionIds = sessions.map((s) => s['id']).toSet();
    final readings = allReadings
        .where((r) => sessionIds.contains(r['session_id']))
        .toList();
    readings.sort(
      (a, b) =>
          (a['recorded_at'] as String).compareTo(b['recorded_at'] as String),
    );
    return readings;
  }

  Future<List<Map<String, dynamic>>> _webGetAllBpProtocols() async {
    final prefs = await webPrefs;
    final data = prefs.getString(_keyBpProtocols);
    if (data == null) return [];
    final items = (jsonDecode(data) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    items.sort(
      (a, b) =>
          (b['start_date'] as String).compareTo(a['start_date'] as String),
    );
    return items;
  }
}
