# bp-protocol-access

## ADDED Requirements

### Requirement: Entry point in existing blood pressure card

The system SHALL provide access to the 7-day BP protocol via a secondary text or icon button within the existing `_buildBloodPressureCard()` widget, labeled "Control 7 días". The existing single-point BP recording functionality SHALL remain the primary visual element of the card.

#### Scenario: User sees access button in dashboard

- **WHEN** user views the dashboard
- **THEN** the blood pressure card displays both single-point recording (primary) and "Control 7 días" button (secondary)

### Requirement: Navigation to protocol screen

The system SHALL navigate to `BloodPressureProtocolScreen` when the user taps "Control 7 días" button.

#### Scenario: User taps "Control 7 días"

- **WHEN** user taps "Control 7 días" button
- **THEN** system navigates to BloodPressureProtocolScreen
