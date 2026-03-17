## 1. HapticService

- [x] 1.1 Create `lib/core/services/haptic_service.dart`
- [x] 1.2 Implement `phaseChange()` method using HapticFeedback.mediumImpact()
- [x] 1.3 Handle exceptions gracefully (try-catch)

## 2. Breathing Screen

- [x] 2.1 Import HapticService in breathing_screen.dart
- [x] 2.2 Add haptic call before setting new phase in _runBreathingCycle()

## 3. Isometrics Screen

- [x] 3.1 Import HapticService in isometrics_screen.dart
- [x] 3.2 Add haptic call in each phase transition

## 4. Verification

- [x] 4.1 Run flutter analyze to ensure code quality (1 pre-existing warning in database_service.dart)
- [x] 4.2 Test breathing screen phase transitions on device
- [x] 4.3 Test isometrics screen phase transitions on device
