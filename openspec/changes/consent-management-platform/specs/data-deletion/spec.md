# Data Deletion

## Status: Proposed

## ADDED Requirements

### Requirement: Delete all data button

The system SHALL provide a "Eliminar todos mis datos" button in the privacy settings section.

#### Scenario: Delete button visible
- **WHEN** user navigates to privacy settings
- **THEN** "Eliminar todos mis datos" button is displayed

### Requirement: First confirmation dialog

The system SHALL show a confirmation dialog after tapping delete: "Esta acción no se puede deshacer. ¿Estás seguro?"

#### Scenario: First confirmation displayed
- **WHEN** user taps "Eliminar todos mis datos"
- **THEN** dialog appears with warning message
- **AND** options "Cancelar" and "Eliminar"

### Requirement: Second confirmation with text input

The system SHALL require the user to type "ELIMINAR" to confirm the action.

#### Scenario: Text input required
- **WHEN** user confirms first dialog
- **THEN** second dialog appears requiring text input
- **AND** deletion only proceeds when user types "ELIMINAR"

### Requirement: Clear SharedPreferences

The system SHALL clear all SharedPreferences on deletion.

#### Scenario: SharedPreferences cleared
- **WHEN** deletion is confirmed
- **THEN** `SharedPreferences.getInstance().clear()` is called

### Requirement: Clear database

The system SHALL delete all records from the local database on deletion.

#### Scenario: Database cleared
- **WHEN** deletion is confirmed
- **THEN** all tables in the database are truncated

### Requirement: Clear local files

The system SHALL delete all files in the application documents directory on deletion.

#### Scenario: Local files deleted
- **WHEN** deletion is confirmed
- **THEN** all files in `getApplicationDocumentsDirectory()` are deleted

### Requirement: Restart with onboarding

The system SHALL restart the app showing the privacy onboarding after deletion completes.

#### Scenario: App restarts with onboarding
- **WHEN** deletion process completes
- **THEN** the app is restarted
- **AND** PrivacyOnboardingScreen is displayed

### Requirement: Progress indicator during deletion

The system SHALL display a progress indicator while deletion is in progress.

#### Scenario: Progress shown during deletion
- **WHEN** deletion starts
- **THEN** a loading indicator is displayed
- **AND** UI is disabled until completion
