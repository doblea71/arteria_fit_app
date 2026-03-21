class BpProtocol {
  final int? id;
  final DateTime startDate;
  final String morningTime;
  final String eveningTime;
  final BpProtocolStatus status;

  BpProtocol({
    this.id,
    required this.startDate,
    required this.morningTime,
    required this.eveningTime,
    required this.status,
  });

  factory BpProtocol.fromMap(Map<String, dynamic> map) {
    return BpProtocol(
      id: map['id'] as int?,
      startDate: DateTime.parse(map['start_date'] as String),
      morningTime: map['morning_time'] as String,
      eveningTime: map['evening_time'] as String,
      status: BpProtocolStatus.fromString(map['status'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'start_date': startDate.toIso8601String(),
      'morning_time': morningTime,
      'evening_time': eveningTime,
      'status': status.value,
    };
  }

  DateTime get morningDateTime {
    final parts = morningTime.split(':');
    return DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  DateTime get eveningDateTime {
    final parts = eveningTime.split(':');
    return DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }
}

enum BpProtocolStatus {
  active,
  completed,
  cancelled;

  String get value => name;

  static BpProtocolStatus fromString(String value) {
    return BpProtocolStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BpProtocolStatus.active,
    );
  }
}
