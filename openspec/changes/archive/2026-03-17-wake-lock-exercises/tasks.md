## 1. Setup

- [x] 1.1 Add `wakelock_plus: ^1.2.4` to pubspec.yaml
- [x] 1.2 Run `flutter pub get`

## 2. Breathing Screen

- [x] 2.1 Import wakelock_plus in breathing_screen.dart
- [x] 2.2 Add WidgetsBindingObserver mixin
- [x] 2.3 Enable wake lock in _startSession()
- [x] 2.4 Disable wake lock in _stopSession()
- [x] 2.5 Handle AppLifecycleState.paused - disable wake lock
- [x] 2.6 Handle AppLifecycleState.resumed - enable wake lock if _isActive
- [x] 2.7 Disable wake lock in dispose()

## 3. Isometrics Screen

- [x] 3.1 Import wakelock_plus in isometrics_screen.dart
- [x] 3.2 Add WidgetsBindingObserver mixin
- [x] 3.3 Enable wake lock in _startExercise()
- [x] 3.4 Disable wake lock when exercise ends (_registerExercise, _pauseExercise)
- [x] 3.5 Handle AppLifecycleState.paused - disable wake lock
- [x] 3.6 Handle AppLifecycleState.resumed - enable wake lock if _isActive
- [x] 3.7 Disable wake lock in dispose()

## 4. Verification

- [x] 4.1 Run flutter analyze to ensure code quality
- [x] 4.2 Test screen stays on during breathing exercise
- [x] 4.3 Test screen stays on during isometric exercise
