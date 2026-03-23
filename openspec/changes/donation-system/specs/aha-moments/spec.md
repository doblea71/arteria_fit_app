# Aha Moments

## Status: Proposed

## ADDED Requirements

### Requirement: Trigger after session 7

The system SHALL show donation prompt after completing session #7 of BP protocol.

#### Scenario: Session 7 completion triggers prompt
- **WHEN** user completes BP protocol session #7
- **AND** shouldShowDonationPrompt() is true
- **THEN** showDonationSheet() is called

### Requirement: Trigger after 20 history records

The system SHALL show donation prompt when viewing history with 20+ records.

#### Scenario: History with 20+ records triggers prompt
- **WHEN** user views BP history screen
- **AND** history contains 20+ readings
- **AND** shouldShowDonationPrompt() is true
- **THEN** showDonationSheet() is called

### Requirement: No duplicate prompts

The system SHALL not show multiple prompts in quick succession.

#### Scenario: Rate limiting prevents duplicates
- **WHEN** prompt is shown
- **AND** user completes another trigger action
- **THEN** prompt is not shown again until 30 days pass

### Requirement: Session completion counter

The system SHALL track total completed BP sessions for triggering.

#### Scenario: Counter accurate
- **WHEN** checking if session #7 is reached
- **THEN** system counts all completed sessions across all protocols

### Requirement: History record counter

The system SHALL count total BP readings for triggering.

#### Scenario: Counter accurate
- **WHEN** checking if 20+ records exist
- **THEN** system counts all readings in blood_pressure_log table
