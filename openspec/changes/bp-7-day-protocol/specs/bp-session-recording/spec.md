# bp-session-recording

## ADDED Requirements

### Requirement: Pre-session recommendations checklist

Before allowing readings, the system SHALL display a checklist of pre-measurement recommendations. The user SHALL confirm having read and understood the recommendations before proceeding.

#### Scenario: Recommendations displayed before session

- **WHEN** user starts a session
- **THEN** system shows BloodPressureRecommendationsScreen with 7 pre-measurement conditions
- **AND** user must tap "Entendido" before entering readings

### Requirement: Three readings per session

The system SHALL provide three input blocks per session for systolic, diastolic, and optional pulse values.

#### Scenario: Session has three reading blocks

- **WHEN** user is in session screen
- **THEN** three reading input blocks are displayed for systolic/diastolic/pulse

### Requirement: 60-second timer between readings

After completing each reading (except the third), the system SHALL display a 60-second countdown timer. The user SHALL NOT be able to enter the next reading until the timer completes.

#### Scenario: Timer blocks next reading

- **WHEN** user completes reading 1
- **AND** attempts to enter reading 2 before timer ends
- **THEN** system shows countdown timer and disables reading 2 input

### Requirement: Optional 5-minute rest timer

The system SHALL offer an optional 5-minute rest timer before the first reading. If activated, the first reading input SHALL be enabled after the countdown completes.

#### Scenario: User activates rest timer

- **WHEN** user taps "Iniciar reposo de 5 minutos"
- **AND** timer counts down to zero
- **THEN** first reading input becomes enabled

### Requirement: Value validation with warnings

The system SHALL validate readings against physiological ranges (systolic 70-250, diastolic 40-150, pulse 30-200). If out of range, the system SHALL display a warning but allow saving.

#### Scenario: Out-of-range systolic reading

- **WHEN** user enters systolic value of 260
- **THEN** system shows warning "Valor fuera del rango fisiológico habitual (70-250 mmHg)"
- **AND** allows user to save the reading

### Requirement: Session completion and state update

After completing the third reading, the system SHALL mark the session as completed and return to the protocol screen.

#### Scenario: Third reading completes

- **WHEN** user saves reading 3
- **THEN** system marks session as completed
- **AND** navigates back to BloodPressureProtocolScreen
