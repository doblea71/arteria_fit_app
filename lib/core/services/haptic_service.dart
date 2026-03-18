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
      // Intentamos ambos métodos para máxima compatibilidad
      HapticFeedback.mediumImpact();
      if (await Vibration.hasVibrator() == true) {
        Vibration.vibrate(
          pattern: [0, 100, 50, 100],
          intensities: [128, 255],
        );
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
    }
  }

  /// Pulso suave para indicar el inicio del descanso
  Future<void> restPhase() async {
    try {
      HapticFeedback.lightImpact();
      if (await Vibration.hasVibrator() == true) {
        Vibration.vibrate(duration: 150, amplitude: 128);
      }
    } catch (e) {
      HapticFeedback.lightImpact();
    }
  }
}
