# Privacy Onboarding

## Status: Proposed

## ADDED Requirements

### Requirement: Show onboarding on first launch

The system SHALL show the PrivacyOnboardingScreen only when `onboarding_privacy_completed` is `false`.

#### Scenario: First launch shows onboarding
- **WHEN** user launches the app for the first time
- **THEN** PrivacyOnboardingScreen is displayed

#### Scenario: Subsequent launch skips onboarding
- **WHEN** user has previously completed onboarding
- **AND** launches the app again
- **THEN** PrivacyOnboardingScreen is NOT displayed

### Requirement: Three-page onboarding flow

The system SHALL display exactly three pages in the onboarding:
- Page 1: "Bienvenido" - Introduction and local data storage info
- Page 2: "Apoya el desarrollo" - Tip Jar and passive monetization with checkboxes
- Page 3: "Tus derechos" - RGPD rights and links to legal documents

#### Scenario: User navigates through all pages
- **WHEN** user taps "Continuar" on page 1
- **THEN** page 2 is displayed
- **WHEN** user taps "Continuar" on page 2
- **THEN** page 3 is displayed

### Requirement: Page progress indicator

The system SHALL display a progress indicator (dots) showing current page position.

#### Scenario: Progress indicator updates
- **WHEN** user is on page 1
- **THEN** indicator shows 3 dots with first dot active
- **WHEN** user navigates to page 2
- **THEN** indicator shows second dot active

### Requirement: Consent checkboxes on page 2

The system SHALL display checkboxes for tip jar and passive monetization consent on page 2.

#### Scenario: Both consents unchecked by default
- **WHEN** user views page 2
- **THEN** both "Tip Jar" and "Monetización pasiva" checkboxes are unchecked

### Requirement: Legal document links

The system SHALL provide links to Privacy Policy and Terms of Use on page 3 using URLs from LegalConstants.

#### Scenario: Links open in browser
- **WHEN** user taps "Política de Privacidad"
- **THEN** the privacy policy URL is opened in the system browser

### Requirement: Complete onboarding saves consents

The system SHALL save all consent values to SharedPreferences when user completes the onboarding.

#### Scenario: Onboarding completion saves data
- **WHEN** user taps "Entendido" on page 3
- **THEN** `onboarding_privacy_completed` is set to `true`
- **AND** consent values are saved to SharedPreferences
- **AND** consent timestamp is recorded

### Requirement: Optional consent continuation

The system SHALL allow user to continue without enabling checkboxes on page 2 (opt-in only).

#### Scenario: User skips consent
- **WHEN** user leaves checkboxes unchecked
- **AND** taps "Más tarde" on page 2
- **THEN** onboarding continues to page 3
- **AND** consents remain `false`
