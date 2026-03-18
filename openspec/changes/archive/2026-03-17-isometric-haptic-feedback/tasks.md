# 1. HapticService Extension

- [x] 1.1 Add `vibration` package to pubspec.yaml with version constraint
- [x] 1.2 Add `contractionPhase()` method to HapticService (double pulse pattern)
- [x] 1.3 Add `restPhase()` method to HapticService (single soft pulse)
- [x] 1.4 Implement fallback to HapticFeedback.mediumImpact() if vibration package fails

## 2. Isometrics Screen

- [x] 2.1 Import HapticService in isometrics_screen.dart
- [x] 2.2 Call contractionPhase() when starting contraction phase
- [x] 2.3 Call restPhase() when starting rest phase

## 3. Verification

- [x] 3.1 Run flutter analyze to ensure code quality
- [x] 3.2 Test isometric exercise on device to verify haptic patterns
