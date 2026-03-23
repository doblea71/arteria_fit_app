## Why

Para monetizar la app sin cuenta de desarrollador en tiendas, se implementa un sistema de donaciones vía enlaces externos (Ko-fi, PayPal) que permite a los usuarios apoyar el desarrollo de Arteria Fit de forma directa y sin comisiones.

## What Changes

- Crear DonationConstants con URLs de plataformas de donación
- Crear DonationService para gestionar lógica de sugerencias y rate limiting
- Crear DonationSheet widget (bottom sheet con opciones de donación)
- Implementar "Aha Moments" - sugerencias en momentos estratégicos
- Añadir sección de donación en Settings
- Mostrar badge "Ya donaste" cuando el usuario reporta haber donado

## Capabilities

### New Capabilities

- `donation-constants`: Constantes con URLs de Ko-fi, PayPal y configuración de prompts
- `donation-service`: Servicio para gestionar mostrar/ocultar sugerencias, rate limiting de 30 días
- `donation-sheet`: Widget bottom sheet con opciones de donación y botón "Quizás más tarde"
- `aha-moments`: Puntos de sugerencia en sesión #7 de BP, historial con 20+ registros
- `donation-settings`: Sección en Settings para apoyar desarrollo con badge de agradecimiento

### Modified Capabilities

- `privacy-settings`: Añadir enlace a sección de donación en Privacy Settings

## Impact

- Nuevo: `lib/core/constants/donation_constants.dart`
- Nuevo: `lib/core/services/donation_service.dart`
- Nuevo: `lib/widgets/donation_sheet.dart`
- Modificado: `lib/features/settings/settings_screen.dart` (sección donación)
- Modificado: `lib/screens/bp_session_screen.dart` (Aha moment)
- Modificado: `lib/screens/bp_history_screen.dart` (Aha moment)
- Dependencias: url_launcher (ya disponible), share_plus (ya disponible)
