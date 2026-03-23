# Donation Sheet

## Status: Proposed

## ADDED Requirements

### Requirement: Show donation bottom sheet

The system SHALL display a bottom sheet with donation options when triggered.

#### Scenario: Bottom sheet displays
- **WHEN** showDonationSheet() is called
- **THEN** a modal bottom sheet appears with donation options

### Requirement: Display title and message

The system SHALL show donation title and message in the sheet.

#### Scenario: Title and message visible
- **WHEN** donation sheet is shown
- **THEN** title "Apoya el desarrollo" is displayed
- **AND** message from DonationConstants is shown

### Requirement: Ko-fi option

The system SHALL provide a Ko-fi donation option as primary.

#### Scenario: Ko-fi tap opens browser
- **WHEN** user taps Ko-fi option
- **THEN** browser opens Ko-fi URL

### Requirement: PayPal option

The system SHALL provide a PayPal donation option as alternative.

#### Scenario: PayPal tap opens browser
- **WHEN** user taps PayPal option
- **THEN** browser opens PayPal.me URL

### Requirement: Dismiss option

The system SHALL provide a "Quizás más tarde" button to dismiss.

#### Scenario: Dismiss records and closes
- **WHEN** user taps "Quizás más tarde"
- **THEN** DonationService.markDonationDismissed() is called
- **AND** bottom sheet is closed

### Requirement: "Ya doné" option

The system SHALL provide an option for users to self-report as donors.

#### Scenario: User marks as donor
- **WHEN** user taps "Ya doné"
- **THEN** DonationService.markAsDonor() is called
- **AND** badge appears in settings
- **AND** sheet is closed
