# Donation Service

## Status: Proposed

## ADDED Requirements

### Requirement: Check if should show donation prompt

The system SHALL provide a method to determine if a donation prompt should be shown based on rate limiting.

#### Scenario: Prompt should show after 30 days
- **WHEN** last prompt was shown more than 30 days ago
- **AND** user has not donated
- **AND** donation consent is given
- **THEN** shouldShowDonationPrompt() returns true

#### Scenario: Prompt should not show within 30 days
- **WHEN** last prompt was shown less than 30 days ago
- **THEN** shouldShowDonationPrompt() returns false

### Requirement: Mark donation prompt as shown

The system SHALL record when a donation prompt is shown.

#### Scenario: Record prompt shown
- **WHEN** donation prompt is displayed
- **THEN** donation_last_shown is updated to current timestamp

### Requirement: Mark donation as dismissed

The system SHALL record when user dismisses donation prompt.

#### Scenario: Record dismiss
- **WHEN** user taps "Quizás más tarde"
- **THEN** donation_dismissed_count is incremented
- **AND** donation_last_shown is updated

### Requirement: Mark as donor

The system SHALL allow user to self-report as donor.

#### Scenario: User marks as donor
- **WHEN** user taps "Ya doné" in settings
- **THEN** donation_made is set to true
- **AND** badge appears in settings

### Requirement: Open donation URL

The system SHALL open donation URLs in external browser.

#### Scenario: Open Ko-fi URL
- **WHEN** user taps Ko-fi option
- **THEN** browser opens Ko-fi URL from DonationConstants

#### Scenario: Open PayPal URL
- **WHEN** user taps PayPal option
- **THEN** browser opens PayPal.me URL from DonationConstants

### Requirement: Check donation consent

The system SHALL respect user's consent for donation prompts.

#### Scenario: Respect consent
- **WHEN** donation_consent is false
- **THEN** shouldShowDonationPrompt() returns false regardless of timing
