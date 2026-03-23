# Passive Monetization Service

## Status: Proposed

## ADDED Requirements

### Requirement: Initialize SDK

The system SHALL provide a method to initialize the monetization SDK.

#### Scenario: SDK initialized
- **WHEN** `initialize(apiKey)` is called
- **THEN** SDK is initialized with provided API key

### Requirement: Check active status

The system SHALL provide a method to check if monetization is active.

#### Scenario: Active returns true
- **WHEN** `isActive()` is called
- **THEN** it returns true if SDK is running

### Requirement: Enable monetization

The system SHALL provide a method to enable monetization.

#### Scenario: Enable called
- **WHEN** `enable()` is called
- **THEN** monetization begins (respecting restrictions)

### Requirement: Disable monetization

The system SHALL provide a method to disable monetization.

#### Scenario: Disable called
- **WHEN** `disable()` is called
- **THEN** monetization stops immediately

### Requirement: Check safe to run

The system SHALL verify device conditions before running.

#### Scenario: Safe conditions
- **WHEN** `canRunSafely()` is called
- **AND** device is on Wi-Fi with battery > 50%
- **THEN** it returns true

#### Scenario: Unsafe conditions
- **WHEN** `canRunSafely()` is called
- **AND** device is on mobile data OR battery <= 50%
- **THEN** it returns false

### Requirement: Get statistics

The system SHALL provide monetization statistics.

#### Scenario: Stats returned
- **WHEN** `getStats()` is called
- **THEN** it returns MonetizationStats with current month data
