## 1. State Management

- [ ] 1.1 Add `_phaseCountdown` integer to track current countdown value
- [ ] 1.2 Add `_phaseCountdownTimer` to manage countdown ticks
- [ ] 1.3 Initialize countdown values in `_runBreathingCycle()` for each phase

## 2. Timer Logic

- [ ] 2.1 Start countdown timer (4s) when Inhale phase starts
- [ ] 2.2 Start countdown timer (7s) when Hold phase starts
- [ ] 2.3 Start countdown timer (8s) when Exhale phase starts
- [ ] 2.4 Cancel previous timer when transitioning between phases

## 3. UI Implementation

- [ ] 3.1 Wrap animation in Stack widget with number as background layer
- [ ] 3.2 Style number with opacity 0.20 and fontSize 200
- [ ] 3.3 Use theme color with opacity for Light/Dark consistency
- [ ] 3.4 Center number in the animation area

## 4. Cleanup

- [ ] 4.1 Cancel countdown timer in dispose() method

## 5. Verification

- [ ] 5.1 Run flutter analyze to ensure code quality
- [ ] 5.2 Test countdown displays correctly for each phase
