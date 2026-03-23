# Privacy Settings

## Status: Proposed

## ADDED Requirements

### Requirement: Privacy section in settings

The system SHALL add a "Privacidad y Apoyo" section to the settings screen.

#### Scenario: Privacy section visible
- **WHEN** user navigates to settings
- **THEN** "Privacidad y Apoyo" section is displayed

### Requirement: Privacy Policy link

The system SHALL provide a link to the Privacy Policy that opens in the system browser.

#### Scenario: Privacy policy link works
- **WHEN** user taps "Política de Privacidad"
- **THEN** the privacy policy URL from LegalConstants is opened

### Requirement: Terms of Use link

The system SHALL provide a link to Terms of Use that opens in the system browser.

#### Scenario: Terms of use link works
- **WHEN** user taps "Términos de Uso"
- **THEN** the terms of use URL from LegalConstants is opened

### Requirement: Consent status display

The system SHALL display the current status of user consents.

#### Scenario: Consent status shown
- **WHEN** user views privacy settings
- **THEN** current consent status is displayed (e.g., "Tip Jar: Activado", "Monetización: Desactivado")

### Requirement: Delete all data action

The system SHALL provide a button to delete all user data (see data-deletion spec).

#### Scenario: Delete button in settings
- **WHEN** user is in privacy settings
- **THEN** "Eliminar todos mis datos" button is visible

### Requirement: Export data action

The system SHALL provide a button to export user data (see data-export spec).

#### Scenario: Export button in settings
- **WHEN** user is in privacy settings
- **THEN** "Exportar mis datos" button is visible
