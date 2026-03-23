# Donation Constants

## Status: Proposed

## ADDED Requirements

### Requirement: Ko-fi URL

The system SHALL provide the Ko-fi donation URL for Arteria Fit.

#### Scenario: Ko-fi URL accessible
- **WHEN** code references DonationConstants.kofiUrl
- **THEN** it returns 'https://ko-fi.com/devdoblea'

### Requirement: PayPal URL

The system SHALL provide the PayPal.me donation URL.

#### Scenario: PayPal URL accessible
- **WHEN** code references DonationConstants.paypalUrl
- **THEN** it returns 'https://paypal.me/devdoblea'

### Requirement: GitHub Sponsors URL

The system SHALL provide the GitHub Sponsors URL (optional).

#### Scenario: GitHub Sponsors URL accessible
- **WHEN** code references DonationConstants.githubSponsorsUrl
- **THEN** it returns 'https://github.com/sponsors/DevDoblea'

### Requirement: Aha Moment configuration

The system SHALL define configuration for when to show donation prompts.

#### Scenario: Configuration values accessible
- **WHEN** accessing DonationConstants
- **THEN** showAfterCompletedSessions equals 7
- **AND** showAfterHistoryRecords equals 20
- **AND** minDaysBetweenPrompts equals 30

### Requirement: Donation prompt text

The system SHALL provide text strings for donation prompts.

#### Scenario: Text constants accessible
- **WHEN** accessing DonationConstants
- **THEN** donationTitle equals 'Apoya el desarrollo'
- **AND** donationMessage contains 'Si Arteria Fit te ha sido útil'
