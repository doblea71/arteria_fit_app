## 1. State Management

- [x] 1.1 Add `_isFinalCycle` boolean flag to track timer expiration
- [x] 1.2 Initialize `_isFinalCycle = false` in state initialization

## 2. Timer Logic

- [x] 2.1 Modify `_timer` callback to set `_isFinalCycle = true` when `_secondsLeft == 0`
- [x] 2.2 Add logic in `_runBreathingCycle()` to check `_isFinalCycle` before starting new cycle
- [x] 2.3 Create `_runFinalExhale()` method that shows "Exhalar" for 8 seconds then calls `_stopSession()`

## 3. Closing Logic

- [x] 3.1 Modify `_stopSession()` to call `_runFinalExhale()` when `_isFinalCycle` is true
- [x] 3.2 Ensure exercise is only registered after completing the final exhale phase

## 4. Verification

- [x] 4.1 Test timer expiration during Inhale phase - verify exhale completes
- [x] 4.2 Test timer expiration during Hold phase - verify exhale completes
- [x] 4.3 Test timer expiration during Exhale phase - verify normal closure
- [x] 4.4 Run flutter analyze to ensure code quality
