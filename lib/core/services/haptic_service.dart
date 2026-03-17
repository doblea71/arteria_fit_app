import 'package:flutter/services.dart';

class HapticService {
  static final HapticService _instance = HapticService._internal();

  factory HapticService() => _instance;

  HapticService._internal();

  Future<void> phaseChange() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      // Silently fail if haptic feedback is not available
    }
  }
}
