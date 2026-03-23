# Donation Settings

## Status: Proposed

## ADDED Requirements

### Requirement: Donation section in settings

The system SHALL add a "Apoyar el desarrollo" section in settings screen.

#### Scenario: Section visible
- **WHEN** user navigates to settings
- **THEN** "Apoyar el desarrollo" section is displayed

### Requirement: Open donation sheet from settings

The system SHALL show donation options when user taps the section.

#### Scenario: Tap opens sheet
- **WHEN** user taps "Apoyar el desarrollo" section
- **THEN** showDonationSheet() is called

### Requirement: Donor badge display

The system SHALL show a badge when user has self-reported as donor.

#### Scenario: Badge visible for donors
- **WHEN** user has donation_made == true
- **AND** user views settings
- **THEN** "Ya donaste" badge is displayed

#### Scenario: No badge for non-donors
- **WHEN** user has donation_made == false
- **AND** user views settings
- **THEN** no donor badge is displayed

### Requirement: Reset donor status option

The system SHALL allow user to reset their donor status.

#### Scenario: Reset available
- **WHEN** user has donation_made == true
- **AND** user wants to reset
- **THEN** option to reset is available in donation section
