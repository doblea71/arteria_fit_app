class BloodPressureReading {
  final int? id;
  final int systolic;
  final int diastolic;
  final int pulse;
  final DateTime createdAt;
  final String? note;

  BloodPressureReading({
    this.id,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.createdAt,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'created_at': createdAt.toIso8601String(),
      'note': note,
    };
  }

  factory BloodPressureReading.fromMap(Map<String, dynamic> map) {
    return BloodPressureReading(
      id: map['id'] as int?,
      systolic: map['systolic'] as int,
      diastolic: map['diastolic'] as int,
      pulse: map['pulse'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      note: map['note'] as String?,
    );
  }

  /// Devuelve el nivel de riesgo según la AHA (American Heart Association)
  String get riskLevel {
    if (systolic < 120 && diastolic < 80) return "Normal";
    if (systolic < 130 && diastolic < 80) return "Elevada";
    if (systolic < 140 || diastolic < 90) return "Hipertensión Nivel 1";
    if (systolic >= 140 || diastolic >= 90) return "Hipertensión Nivel 2";
    if (systolic > 180 || diastolic > 120) return "Crisis Hipertensiva";
    return "Desconocido";
  }
}
