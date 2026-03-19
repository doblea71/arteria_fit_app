import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class HapticService {
  static final HapticService _instance = HapticService._internal();

  factory HapticService() => _instance;

  HapticService._internal();

  /// Vibración estándar para cambios de fase genéricos
  Future<void> phaseChange() async {
    try {
      debugPrint('HapticService: Ejecutando phaseChange');
      // Feedback táctil inmediato nativo
      await HapticFeedback.mediumImpact();
      
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        await Vibration.vibrate(duration: 200);
      }
    } catch (e) {
      debugPrint('HapticService Error (phaseChange): $e');
      // Fallback garantizado
      await HapticFeedback.mediumImpact();
    }
  }

  /// Doble pulso fuerte para iniciar fase activa (contracción)
  Future<void> contractionPhase() async {
    try {
      debugPrint('HapticService: Ejecutando contractionPhase (Buscando máximo feedback)');
      
      // Feedback nativo inmediato (funciona en casi todo iOS/Android)
      await HapticFeedback.heavyImpact();
      
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        final hasCustomSupport = await Vibration.hasCustomVibrationsSupport();
        
        if (hasCustomSupport) {
          debugPrint('HapticService: Usando patrón personalizado');
          // Patrón: espera 0, vibra 250, espera 150, vibra 250
          // Longitud pattern = 4, Longitud intensities = 4
          await Vibration.vibrate(
            pattern: [0, 250, 150, 250],
            intensities: [0, 255, 0, 255], 
          );
        } else {
          debugPrint('HapticService: No soporta patrones, usando vibración simple larga');
          await Vibration.vibrate(duration: 600); // Corrected 'duversion' to 'duration'
        }
      }
    } catch (e) {
      debugPrint('HapticService Error (contractionPhase): $e');
      await HapticFeedback.heavyImpact();
    }
  }

  /// Pulso suave para indicar el inicio del descanso
  Future<void> restPhase() async {
    try {
      debugPrint('HapticService: Ejecutando restPhase');
      await HapticFeedback.lightImpact();
      
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        // Vibración más larga pero suave (amplitud baja si se soporta)
        await Vibration.vibrate(duration: 400, amplitude: 100);
      }
    } catch (e) {
      debugPrint('HapticService Error (restPhase): $e');
      await HapticFeedback.lightImpact();
    }
  }
}
