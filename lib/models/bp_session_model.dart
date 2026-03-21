import 'bp_reading_model.dart' show BpReading;

class BpSession {
  final int? id;
  final int protocolId;
  final int dayNumber;
  final BpSessionType sessionType;
  final DateTime scheduledAt;
  final BpSessionStatus status;
  final List<BpReading> readings;

  BpSession({
    this.id,
    required this.protocolId,
    required this.dayNumber,
    required this.sessionType,
    required this.scheduledAt,
    required this.status,
    List<BpReading>? readings,
  }) : readings = readings ?? [];

  factory BpSession.fromMap(Map<String, dynamic> map) {
    return BpSession(
      id: map['id'] as int?,
      protocolId: map['protocol_id'] as int,
      dayNumber: map['day_number'] as int,
      sessionType: BpSessionType.fromString(map['session_type'] as String),
      scheduledAt: DateTime.parse(map['scheduled_at'] as String),
      status: BpSessionStatus.fromString(map['status'] as String),
      readings: map['readings'] != null
          ? (map['readings'] as List)
              .map((r) => BpReading.fromMap(r as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'protocol_id': protocolId,
      'day_number': dayNumber,
      'session_type': sessionType.value,
      'scheduled_at': scheduledAt.toIso8601String(),
      'status': status.value,
    };
  }

  bool get isCompleted => status == BpSessionStatus.completed;
  bool get isPending => status == BpSessionStatus.pending;
  bool get isInProgress => status == BpSessionStatus.inProgress;

  String get displayTime {
    final hour = scheduledAt.hour.toString().padLeft(2, '0');
    final minute = scheduledAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get displayDate {
    return '${scheduledAt.day}/${scheduledAt.month}/${scheduledAt.year}';
  }

  double? get averageSystolic {
    if (readings.isEmpty) return null;
    return readings.map((r) => r.systolic).reduce((a, b) => a + b) / readings.length;
  }

  double? get averageDiastolic {
    if (readings.isEmpty) return null;
    return readings.map((r) => r.diastolic).reduce((a, b) => a + b) / readings.length;
  }
}

enum BpSessionType {
  morning,
  evening;

  String get value => name;

  static BpSessionType fromString(String value) {
    return BpSessionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BpSessionType.morning,
    );
  }

  String get displayName {
    switch (this) {
      case BpSessionType.morning:
        return 'Mañana';
      case BpSessionType.evening:
        return 'Noche';
    }
  }
}

enum BpSessionStatus {
  pending,
  inProgress,
  completed,
  skipped;

  String get value => name;

  static BpSessionStatus fromString(String value) {
    return BpSessionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BpSessionStatus.pending,
    );
  }
}
