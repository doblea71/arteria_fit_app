# Passive Support Toggle

## Status: Proposed

## ADDED Requirements

### Requirement: Display toggle widget

The system SHALL display a toggle to enable/disable passive monetization.

#### Scenario: Toggle displayed
- **WHEN** widget is rendered
- **THEN** toggle shows current state

### Requirement: Toggle changes state

The system SHALL respond to toggle changes.

#### Scenario: Toggle turned on
- **WHEN** user enables toggle
- **AND** conditions are safe (Wi-Fi + battery > 50%)
- **THEN** monetization is enabled

#### Scenario: Toggle turned off
- **WHEN** user disables toggle
- **THEN** monetization is stopped

### Requirement: Display statistics

The system SHALL show current month's statistics.

#### Scenario: Stats displayed
- **WHEN** widget is shown
- **THEN** displays "Este mes: X MB compartidos"

### Requirement: Respect consent

The system SHALL only function if user consented to passive monetization.

#### Scenario: Consent not given
- **WHEN** `passive_monetization_consent` is false
- **THEN** toggle is disabled or hidden
