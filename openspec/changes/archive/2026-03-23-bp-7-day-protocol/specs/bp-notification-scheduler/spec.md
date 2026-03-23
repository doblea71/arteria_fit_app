# bp-notification-scheduler

## ADDED Requirements

### Requirement: 10-minute advance notification

The system SHALL schedule a local notification 10 minutes before each session (14 total), even if the app is closed or in background.

#### Scenario: Advance notification fires

- **WHEN** a session is scheduled for 07:30
- **AND** current time reaches 07:20
- **THEN** device shows notification "Recordatorio: Sesión matutina en 10 minutos"

### Requirement: Session start notification

The system SHALL schedule a notification at the exact session time indicating it's time to start readings.

#### Scenario: Session start notification

- **WHEN** session time is reached
- **AND** user has not opened app
- **THEN** device shows notification "Es hora de iniciar tu sesión de tensión arterial"

### Requirement: Background notification support

Notifications SHALL fire with app in background or closed. This requires proper Android manifest configuration and notification service initialization.

#### Scenario: Notification with app closed

- **WHEN** notification time arrives
- **AND** app is not running
- **THEN** notification still appears on device

### Requirement: Permission request at protocol start

The system SHALL request notification permissions when the user starts a protocol (not during app onboarding). If denied, the system SHALL inform the user that reminders won't be received.

#### Scenario: Permission denied

- **WHEN** user denies notification permission
- **AND** attempts to start protocol
- **THEN** system shows info "No recibirás recordatorios. Puedes continuar con el protocolo manualmente."

### Requirement: Cancel notifications on protocol cancellation

When a protocol is cancelled, all pending notifications SHALL be cancelled.

#### Scenario: Notifications cancelled on cancel

- **WHEN** user cancels active protocol
- **AND** notifications were scheduled
- **THEN** all pending notifications are cancelled

### Requirement: Cancel remaining notifications on completion

When day 7 is completed, any remaining pending notifications SHALL be cancelled.

#### Scenario: Notifications cleared on completion

- **WHEN** final session (day 7 evening) is completed
- **AND** there are no more scheduled sessions
- **THEN** all pending notifications are cancelled
