# Consent Manager

## Status: Proposed

## ADDED Requirements

### Requirement: Onboarding completion tracking

The system SHALL track whether the user has completed the privacy onboarding using `onboarding_privacy_completed` key in SharedPreferences with default value `false`.

#### Scenario: First app launch
- **WHEN** user launches the app for the first time
- **THEN** `onboarding_privacy_completed` is `false`

#### Scenario: Onboarding completed
- **WHEN** user completes the privacy onboarding
- **THEN** `onboarding_privacy_completed` is set to `true`

### Requirement: Tip Jar consent

The system SHALL track tip jar consent using `tip_jar_consent` key with default value `false`.

#### Scenario: User accepts tip jar
- **WHEN** user enables tip jar consent in onboarding or settings
- **THEN** `tip_jar_consent` is set to `true`

#### Scenario: User declines tip jar
- **WHEN** user declines tip jar consent
- **THEN** `tip_jar_consent` remains `false`

### Requirement: Passive monetization consent

The system SHALL track passive monetization consent using `passive_monetization_consent_given` key with default value `false`.

#### Scenario: User gives passive monetization consent
- **WHEN** user explicitly consents to passive monetization
- **THEN** `passive_monetization_consent_given` is set to `true`

### Requirement: Passive monetization enabled

The system SHALL track whether passive monetization is enabled using `passive_monetization_enabled` key with default value `false`.

#### Scenario: Passive monetization toggled on
- **WHEN** user toggles passive monetization to on (requires consent)
- **THEN** `passive_monetization_enabled` is set to `true`

### Requirement: Get all consents

The system SHALL provide a method `getAllConsents()` that returns a Map containing all consent values.

#### Scenario: Get all consents returns complete map
- **WHEN** `getAllConsents()` is called
- **THEN** it returns `{onboarding_privacy_completed: bool, tip_jar_consent: bool, passive_monetization_consent_given: bool, passive_monetization_enabled: bool, consent_timestamp: String?}`

### Requirement: Update individual consent

The system SHALL provide a method `updateConsent(String key, bool value)` to update individual consent values.

#### Scenario: Update consent value
- **WHEN** `updateConsent('tip_jar_consent', true)` is called
- **THEN** the `tip_jar_consent` value in SharedPreferences is updated to `true`

### Requirement: Delete all user data

The system SHALL provide a method `deleteAllUserData()` that clears all user data including SharedPreferences, database, and local files.

#### Scenario: Delete all data
- **WHEN** `deleteAllUserData()` is called
- **THEN** all SharedPreferences are cleared
- **AND** all database records are deleted
- **AND** all files in application documents directory are deleted

### Requirement: Export user data

The system SHALL provide a method `exportUserData()` that returns all user data as a Map for JSON export.

#### Scenario: Export returns all data
- **WHEN** `exportUserData()` is called
- **THEN** it returns a Map containing all stored data formatted for JSON export
