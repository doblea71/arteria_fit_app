import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class HapticService {
  static final HapticService _instance = HapticService._internal();

  factory HapticService() => _instance;

  HapticService._internal();

  /// Vibración estándar para cambios de fase genéricos
  Future<void> phaseChange() async {
    try {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 200);
      } else {
        await HapticFeedback.mediumImpact();
      }
    } catch (e) {
      // Silently fail if haptic feedback is not available
    }
  }

  /// Doble pulso para alertar el inicio de la fase de contracción
  Future<void> contractionPhase() async {
    try {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(pattern: [0, 200, 100, 400]);
      } else {
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        await HapticFeedback.heavyImpact();
      }
    } catch (e) {
      await HapticFeedback.heavyImpact();
    }
  }

  /// Pulso suave para indicar el inicio del descanso
  Future<void> restPhase() async {
    try {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 100, amplitude: 128);
      } else {
        await HapticFeedback.lightImpact();
      }
    } catch (e) {
      await HapticFeedback.lightImpact();
    }
  }
}
