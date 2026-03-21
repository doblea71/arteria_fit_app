class BpReading {
  final int? id;
  final int sessionId;
  final int readingIndex;
  final int systolic;
  final int diastolic;
  final int? pulse;
  final DateTime recordedAt;

  BpReading({
    this.id,
    required this.sessionId,
    required this.readingIndex,
    required this.systolic,
    required this.diastolic,
    this.pulse,
    required this.recordedAt,
  });

  factory BpReading.fromMap(Map<String, dynamic> map) {
    return BpReading(
      id: map['id'] as int?,
      sessionId: map['session_id'] as int,
      readingIndex: map['reading_index'] as int,
      systolic: map['systolic'] as int,
      diastolic: map['diastolic'] as int,
      pulse: map['pulse'] as int?,
      recordedAt: DateTime.parse(map['recorded_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'session_id': sessionId,
      'reading_index': readingIndex,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }

  bool get isValidSystolic => systolic >= 70 && systolic <= 250;
  bool get isValidDiastolic => diastolic >= 40 && diastolic <= 150;
  bool get isValidPulse => pulse == null || (pulse! >= 30 && pulse! <= 200);

  bool get hasWarning {
    return !isValidSystolic || !isValidDiastolic || !isValidPulse;
  }

  String? get systolicWarning {
    if (isValidSystolic) return null;
    return 'Valor fuera del rango fisiológico habitual (70-250 mmHg)';
  }

  String? get diastolicWarning {
    if (isValidDiastolic) return null;
    return 'Valor fuera del rango fisiológico habitual (40-150 mmHg)';
  }

  String? get pulseWarning {
    if (isValidPulse) return null;
    return 'Valor fuera del rango fisiológico habitual (30-200 lpm)';
  }
}
