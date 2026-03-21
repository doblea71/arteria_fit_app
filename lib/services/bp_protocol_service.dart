import '../core/services/database_service.dart';
import '../models/bp_protocol_model.dart';
import '../models/bp_session_model.dart';
import '../models/bp_reading_model.dart';
import 'notification_service.dart';

class BpProtocolService {
  final DatabaseService _db = DatabaseService();
  final NotificationService _notifications = NotificationService();

  Future<BpProtocol?> getActiveProtocol() async {
    final map = await _db.getActiveBpProtocol();
    if (map == null) return null;
    return BpProtocol.fromMap(map);
  }

  Future<bool> hasActiveProtocol() async {
    final protocol = await getActiveProtocol();
    return protocol != null;
  }

  Future<BpProtocol> startProtocol({
    required String morningTime,
    required String eveningTime,
  }) async {
    final hasActive = await hasActiveProtocol();
    if (hasActive) {
      throw Exception('Ya existe un protocolo activo');
    }

    final now = DateTime.now();
    final protocolId = await _db.insertBpProtocol(
      startDate: now.toIso8601String(),
      morningTime: morningTime,
      eveningTime: eveningTime,
      status: 'active',
    );

    await _generateSessions(protocolId, now, morningTime, eveningTime);

    return (await getActiveProtocol())!;
  }

  Future<void> _generateSessions(
    int protocolId,
    DateTime startDate,
    String morningTime,
    String eveningTime,
  ) async {
    final morningParts = morningTime.split(':');
    final eveningParts = eveningTime.split(':');

    for (int day = 1; day <= 7; day++) {
      final sessionDate = startDate.add(Duration(days: day - 1));

      final morningDateTime = DateTime(
        sessionDate.year,
        sessionDate.month,
        sessionDate.day,
        int.parse(morningParts[0]),
        int.parse(morningParts[1]),
      );

      final eveningDateTime = DateTime(
        sessionDate.year,
        sessionDate.month,
        sessionDate.day,
        int.parse(eveningParts[0]),
        int.parse(eveningParts[1]),
      );

      await _db.insertBpSession(
        protocolId: protocolId,
        dayNumber: day,
        sessionType: 'morning',
        scheduledAt: morningDateTime.toIso8601String(),
        status: 'pending',
      );

      await _db.insertBpSession(
        protocolId: protocolId,
        dayNumber: day,
        sessionType: 'evening',
        scheduledAt: eveningDateTime.toIso8601String(),
        status: 'pending',
      );
    }
  }

  Future<void> cancelProtocol() async {
    final protocol = await getActiveProtocol();
    if (protocol == null) return;

    final sessions = await getProtocolSessions(protocol.id!);
    final notificationIds = <int>[];
    
    for (final session in sessions) {
      if (session.status == BpSessionStatus.pending) {
        notificationIds.add(_notifications.generateNotificationId(
          protocol.id!, session.dayNumber, session.sessionType == BpSessionType.morning, true,
        ));
        notificationIds.add(_notifications.generateNotificationId(
          protocol.id!, session.dayNumber, session.sessionType == BpSessionType.morning, false,
        ));
      }
    }

    await _notifications.cancelByIds(notificationIds);
    await _db.updateBpProtocolStatus(protocol.id!, 'cancelled');
  }

  Future<List<BpSession>> getProtocolSessions(int protocolId) async {
    final maps = await _db.getBpSessionsWithReadings(protocolId);
    return maps.map((m) => BpSession.fromMap(m)).toList();
  }

  Future<BpSession?> getSession(int sessionId) async {
    final map = await _db.getBpSession(sessionId);
    if (map == null) return null;
    
    final readingsMaps = await _db.getBpReadingsBySession(sessionId);
    
    return BpSession.fromMap({
      ...map,
      'readings': readingsMaps,
    });
  }

  Future<void> saveReading({
    required int sessionId,
    required int readingIndex,
    required int systolic,
    required int diastolic,
    int? pulse,
  }) async {
    await _db.insertBpReading(
      sessionId: sessionId,
      readingIndex: readingIndex,
      systolic: systolic,
      diastolic: diastolic,
      pulse: pulse,
    );

    if (readingIndex == 3) {
      await _db.updateBpSessionStatus(sessionId, 'completed');
      
      final currentSession = await _db.getBpSession(sessionId);
      if (currentSession != null) {
        final allSessions = await _db.getBpSessionsByProtocol(currentSession['protocol_id'] as int);
        final allCompleted = allSessions.every(
          (s) => s['status'] == 'completed',
        );
        if (allCompleted) {
          await _db.updateBpProtocolStatus(currentSession['protocol_id'] as int, 'completed');
          await _notifications.cancelAll();
        }
      }
    }
  }

  Future<BpResults> getResults(int protocolId) async {
    final readingsMaps = await _db.getAllBpReadingsForProtocol(protocolId);
    final sessions = await _db.getBpSessionsWithReadings(protocolId);
    
    final allReadings = readingsMaps.map((m) => BpReading.fromMap(m)).toList();
    final validReadings = allReadings.where((r) {
      final session = sessions.firstWhere((s) => s['id'] == r.sessionId);
      return (session['day_number'] as int) > 1;
    }).toList();

    final morningReadings = <BpReading>[];
    final eveningReadings = <BpReading>[];

    for (final reading in validReadings) {
      final session = sessions.firstWhere((s) => s['id'] == reading.sessionId);
      if (session['session_type'] == 'morning') {
        morningReadings.add(reading);
      } else {
        eveningReadings.add(reading);
      }
    }

    final avgSystolic = validReadings.isEmpty
        ? 0.0
        : validReadings.map((r) => r.systolic).reduce((a, b) => a + b) / validReadings.length;

    final avgDiastolic = validReadings.isEmpty
        ? 0.0
        : validReadings.map((r) => r.diastolic).reduce((a, b) => a + b) / validReadings.length;

    final avgMorningSystolic = morningReadings.isEmpty
        ? 0.0
        : morningReadings.map((r) => r.systolic).reduce((a, b) => a + b) / morningReadings.length;

    final avgMorningDiastolic = morningReadings.isEmpty
        ? 0.0
        : morningReadings.map((r) => r.diastolic).reduce((a, b) => a + b) / morningReadings.length;

    final avgEveningSystolic = eveningReadings.isEmpty
        ? 0.0
        : eveningReadings.map((r) => r.systolic).reduce((a, b) => a + b) / eveningReadings.length;

    final avgEveningDiastolic = eveningReadings.isEmpty
        ? 0.0
        : eveningReadings.map((r) => r.diastolic).reduce((a, b) => a + b) / eveningReadings.length;

    final expectedReadings = 12;
    final totalReadings = validReadings.length;
    final completedDays = sessions
        .where((s) => s['status'] == 'completed' && (s['day_number'] as int) > 1)
        .map((s) => s['day_number'])
        .toSet()
        .length;

    return BpResults(
      averageSystolic: avgSystolic,
      averageDiastolic: avgDiastolic,
      averageMorningSystolic: avgMorningSystolic,
      averageMorningDiastolic: avgMorningDiastolic,
      averageEveningSystolic: avgEveningSystolic,
      averageEveningDiastolic: avgEveningDiastolic,
      totalReadings: totalReadings,
      expectedReadings: expectedReadings,
      completedDays: completedDays,
      readings: validReadings,
    );
  }

  Future<void> scheduleNotificationsForProtocol(BpProtocol protocol) async {
    final sessions = await getProtocolSessions(protocol.id!);
    
    for (final session in sessions) {
      if (session.status == BpSessionStatus.pending) {
        final isMorning = session.sessionType == BpSessionType.morning;
        
        final advanceId = _notifications.generateNotificationId(
          protocol.id!, session.dayNumber, isMorning, true,
        );
        final startId = _notifications.generateNotificationId(
          protocol.id!, session.dayNumber, isMorning, false,
        );

        await _notifications.scheduleAdvanceNotification(
          id: advanceId,
          sessionTime: session.scheduledAt,
          isMorning: isMorning,
        );

        await _notifications.scheduleStartNotification(
          id: startId,
          sessionTime: session.scheduledAt,
          isMorning: isMorning,
        );
      }
    }
  }

  Future<List<ProtocolSummary>> getProtocolHistory() async {
    final protocols = await _db.getAllBpProtocols();
    final summaries = <ProtocolSummary>[];
    
    for (final map in protocols) {
      final protocol = BpProtocol.fromMap(map);
      final sessions = await getProtocolSessions(protocol.id!);
      final completed = sessions.where((s) => s.isCompleted).length;
      final results = await getResults(protocol.id!);
      
      summaries.add(ProtocolSummary(
        protocol: protocol,
        completedSessions: completed,
        totalSessions: sessions.length,
        avgSystolic: results.hasResults ? results.averageSystolic : null,
        avgDiastolic: results.hasResults ? results.averageDiastolic : null,
      ));
    }
    
    return summaries;
  }
}

class ProtocolSummary {
  final BpProtocol protocol;
  final int completedSessions;
  final int totalSessions;
  final double? avgSystolic;
  final double? avgDiastolic;

  ProtocolSummary({
    required this.protocol,
    required this.completedSessions,
    required this.totalSessions,
    this.avgSystolic,
    this.avgDiastolic,
  });

  bool get hasResults => avgSystolic != null && avgDiastolic != null;
  String get statusText {
    switch (protocol.status) {
      case BpProtocolStatus.active:
        return 'Activo';
      case BpProtocolStatus.completed:
        return 'Completado';
      case BpProtocolStatus.cancelled:
        return 'Cancelado';
    }
  }
}

class BpResults {
  final double averageSystolic;
  final double averageDiastolic;
  final double averageMorningSystolic;
  final double averageMorningDiastolic;
  final double averageEveningSystolic;
  final double averageEveningDiastolic;
  final int totalReadings;
  final int expectedReadings;
  final int completedDays;
  final List<BpReading> readings;

  BpResults({
    required this.averageSystolic,
    required this.averageDiastolic,
    required this.averageMorningSystolic,
    required this.averageMorningDiastolic,
    required this.averageEveningSystolic,
    required this.averageEveningDiastolic,
    required this.totalReadings,
    required this.expectedReadings,
    required this.completedDays,
    required this.readings,
  });

  bool get hasResults => totalReadings > 0;
  bool get hasPartialResults => completedDays >= 1;
  bool get isAboveThreshold => averageSystolic >= 135 || averageDiastolic >= 85;

  String get interpretation {
    if (isAboveThreshold) {
      return 'Sus promedios superan el umbral de referencia domiciliario (135/85 mmHg). Se recomienda consultar con su médico.';
    }
    return 'Sus promedios se encuentran dentro del rango de referencia domiciliario.';
  }

  String get disclaimer {
    return 'Este resultado es orientativo y no constituye un diagnóstico médico.';
  }
}
