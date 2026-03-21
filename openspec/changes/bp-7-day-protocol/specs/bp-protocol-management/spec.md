# bp-protocol-management

## ADDED Requirements

### Requirement: Protocol start with time selection

The system SHALL prompt the user to select morning session time and evening session time before starting a new protocol. The system SHALL validate that the difference between times is minimum 6 hours and maximum 9 hours. If validation fails, the system SHALL display an error and prevent continuation.

#### Scenario: User starts protocol with valid times

- **WHEN** user selects morning time 07:30 and evening time 20:00
- **AND** confirms the start
- **THEN** system creates a new protocol with 14 sessions (7 morning + 7 evening)

#### Scenario: User starts protocol with invalid times

- **WHEN** user selects morning time 07:30 and evening time 12:00
- **AND** confirms the start
- **THEN** system displays error "La diferencia entre sesiones debe ser de 6 a 9 horas"

### Requirement: Automatic 7-day calendar generation

The system SHALL automatically generate 14 sessions (7 morning + 7 evening) with real dates and times based on start date and selected times, without requiring manual configuration per day.

#### Scenario: Protocol generates correct calendar

- **WHEN** user starts protocol on March 20 with morning 07:30 and evening 20:00
- **THEN** system generates sessions for March 20-26 at 07:30 and 20:00

### Requirement: Single active protocol constraint

The system SHALL allow only one active protocol at a time. If user attempts to start a new protocol with an existing active one, the system SHALL display a confirmation dialog warning that the active protocol will be cancelled.

#### Scenario: User tries to start second protocol

- **WHEN** active protocol exists
- **AND** user attempts to start new protocol
- **THEN** system shows dialog: "Hay un protocolo activo. ¿Deseas cancelarlo e iniciar uno nuevo?"

### Requirement: Protocol state display

The system SHALL display the current protocol state: Not Started, In Progress, or Completed. When in progress, the system SHALL display a 7-day calendar showing session completion status.

#### Scenario: Protocol in progress shows calendar

- **WHEN** protocol is active
- **THEN** BloodPressureProtocolScreen displays 7 day cards with morning/evening session status

### Requirement: Protocol cancellation

The system SHALL allow the user to cancel an active protocol. When cancelled, all pending notifications SHALL be cancelled and the protocol status updated to 'cancelled'.

#### Scenario: User cancels protocol

- **WHEN** user taps "Cancelar protocolo"
- **AND** confirms in dialog
- **THEN** system cancels pending notifications and updates protocol status to 'cancelled'
