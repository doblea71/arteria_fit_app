## ADDED Requirements

### Requirement: Complete exhale phase when timer expires during inhale or hold
When the global timer reaches 0 and the 4-7-8 cycle is in either Inhale or Hold phase, the system MUST advance the cycle to initiate the Exhale phase before closing the exercise.

#### Scenario: Timer expires during Inhale phase
- **WHEN** the global timer reaches 0 during the Inhale phase (4s)
- **THEN** the system advances to Hold phase and then to Exhale, showing "Exhalar" for 8 seconds before closing

#### Scenario: Timer expires during Hold phase
- **WHEN** the global timer reaches 0 during the Hold phase (7s)
- **THEN** the system advances directly to Exhale phase, showing "Exhalar" for 8 seconds before closing

### Requirement: Show "Exhalar" indicator for exactly 8 seconds
Once the forced Exhale phase is initiated at the end of the timer, the system MUST display the visual "Exhalar" indicator for exactly 8 seconds, regardless of the remaining global timer time.

#### Scenario: Exhale indicator displays for 8 seconds
- **WHEN** the forced Exhale phase starts after timer expiration
- **THEN** "Exhalar" indicator displays for exactly 8 seconds

### Requirement: Close exercise after final exhale
After the 8 seconds of the final Exhale phase, the system MUST execute the current closing logic: reactivate control buttons and stop the animation.

#### Scenario: Exercise closes after exhale completion
- **WHEN** the 8-second Exhale phase completes
- **THEN** the exercise closes, buttons become active, animation stops, and exercise is registered

### Requirement: Do not start new cycle after final exhale
The system MUST NOT start a new 4-7-8 cycle after the forced exhale when the global timer has expired.

#### Scenario: No new cycle starts after final exhale
- **WHEN** the forced Exhale phase completes after timer expiration
- **THEN** no new breathing cycle begins, exercise remains in resting state
