## Why

Para cumplir con el RGPD y preparar la monetización de la app (donaciones + monetización pasiva), es necesario implementar un Centro de Gestión de Consentimiento (CMP) que informe al usuario sobre el tratamiento de sus datos y obtenga su consentimiento explícito antes de cualquier funcionalidad de monetización.

## What Changes

- Crear ConsentManager Service para gestionar preferencias de consentimiento
- Implementar PrivacyOnboardingScreen con 3 páginas de onboarding
- Integrar onboarding en el flujo de inicio de la app (solo primera ejecución)
- Añadir sección "Privacidad y Apoyo" en Settings
- Implementar eliminación de datos con doble confirmación
- Implementar exportación de datos en JSON (portabilidad RGPD)

## Capabilities

### New Capabilities

- `consent-manager`: Servicio centralizado para gestionar consentimiento del usuario usando SharedPreferences
- `privacy-onboarding`: Pantalla de onboarding de 3 páginas con información RGPD y opciones de consentimiento
- `data-deletion`: Funcionalidad para eliminar todos los datos del usuario con confirmación
- `data-export`: Exportación de datos en JSON para cumplimiento de portabilidad RGPD
- `privacy-settings`: Sección en Settings para gestionar privacidad y consentimientos

### Modified Capabilities

- Ninguno

## Impact

- Nuevo: `lib/core/services/consent_manager.dart`
- Nuevo: `lib/screens/onboarding/privacy_onboarding_screen.dart`
- Nuevo: `lib/widgets/consent_toggle.dart`
- Modificado: `lib/features/settings/settings_screen.dart` (añadir sección privacidad)
- Dependencias: SharedPreferences (ya disponible en Flutter)
- Dependencias externas: SPEC-015 (legal_constants.dart con URLs legales)
