## 1. Fix Breathing Screen Vibration

- [x] 1.1 Add haptic vibration AFTER setState for inhale phase in _runBreathingCycle()
- [x] 1.2 Move haptic vibration for hold phase AFTER setState
- [x] 1.3 Move haptic vibration for exhale phase AFTER setState
- [x] 1.4 Ensure NO vibration is added in _runFinalExhale() for inhale

## 2. Verification

- [x] 2.1 Run flutter analyze to ensure code quality
- [x] 2.2 Verify 3 vibrations per cycle (Inhale, Hold, Exhale)
