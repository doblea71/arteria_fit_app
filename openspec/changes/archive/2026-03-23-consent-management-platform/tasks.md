## 1. Consent Manager Service

- [x] 1.1 Create `lib/core/services/consent_manager.dart`
- [x] 1.2 Implement `hasCompletedOnboarding()` method
- [x] 1.3 Implement `completeOnboarding()` method
- [x] 1.4 Implement `getAllConsents()` method
- [x] 1.5 Implement `updateConsent()` method
- [x] 1.6 Implement `deleteAllUserData()` method
- [x] 1.7 Implement `exportUserData()` method

## 2. Privacy Onboarding Screen

- [x] 2.1 Create `lib/screens/onboarding/privacy_onboarding_screen.dart`
- [x] 2.2 Implement PageView with 3 pages
- [x] 2.3 Create Page 1: "Bienvenido" content
- [x] 2.4 Create Page 2: "Apoya el desarrollo" with checkboxes
- [x] 2.5 Create Page 3: "Tus derechos" with legal links
- [x] 2.6 Add page progress indicator (dots)
- [x] 2.7 Implement "Continuar" and "Más tarde" buttons
- [x] 2.8 Implement save consents on completion

## 3. Onboarding Integration

- [x] 3.1 Modify `lib/main.dart` or app entry to check onboarding status
- [x] 3.2 Add conditional navigation to PrivacyOnboardingScreen
- [ ] 3.3 Test first launch shows onboarding
- [ ] 3.4 Test subsequent launches skip onboarding

## 4. Privacy Settings Section

- [x] 4.1 Modify `lib/features/settings/settings_screen.dart`
- [x] 4.2 Add "Privacidad y Apoyo" section header
- [x] 4.3 Add "Política de Privacidad" link
- [x] 4.4 Add "Términos de Uso" link
- [x] 4.5 Add consent status display
- [x] 4.6 Add "Eliminar todos mis datos" button
- [x] 4.7 Add "Exportar mis datos" button

## 5. Data Deletion Implementation

- [x] 5.1 Implement first confirmation dialog
- [x] 5.2 Implement second confirmation with text input ("ELIMINAR")
- [x] 5.3 Implement SharedPreferences clear
- [x] 5.4 Implement database deleteAll
- [x] 5.5 Implement local files deletion
- [x] 5.6 Add progress indicator during deletion
- [x] 5.7 Implement app restart with onboarding

## 6. Data Export Implementation

- [x] 6.1 Implement JSON generation from all data sources
- [x] 6.2 Add blood pressure readings to export
- [x] 6.3 Add protocol data to export
- [x] 6.4 Add preferences to export
- [x] 6.5 Add consent status to export
- [x] 6.6 Implement share functionality with share_plus
- [x] 6.7 Handle empty data case

## 7. Consent Toggle Widget (Optional Reusable)

- [x] 7.1 Create `lib/widgets/consent_toggle.dart`
- [x] 7.2 Add title and description parameters
- [x] 7.3 Implement toggle state management
- [x] 7.4 Add callback for state changes

## 8. Testing & Verification

- [x] 8.1 Run `flutter analyze` to verify no issues
- [x] 8.2 Test onboarding flow on fresh install ✓
- [x] 8.3 Test consent checkboxes work correctly ✓
- [x] 8.4 Test data deletion with double confirmation ✓
- [x] 8.5 Test data export generates valid JSON ✓
- [x] 8.6 Test Light/Dark theme consistency ✓
