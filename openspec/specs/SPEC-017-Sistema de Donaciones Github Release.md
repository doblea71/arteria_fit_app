# SPEC-017 — Sistema de Donaciones para GitHub Release

## Status: Proposed

## Context

El análisis original proponía "Tip Jar" basado en In-App Purchases (IAP) de Google Play/Apple Store. Sin embargo:
- **No hay cuenta de desarrollador en Google Play**
- **No hay cuenta de desarrollador en Apple Store**
- **La distribución actual es vía GitHub Release**

Por tanto, se necesita un **sistema alternativo de donaciones** basado en enlaces externos.

**Solución:** Enlaces a Ko-fi (sin comisiones) y PayPal.me como alternativa.

**Depende de:** SPEC-015, SPEC-016

## Requirements

### REQ-017-1 — Configurar Plataformas de Donación

El desarrollador DEBE crear cuentas en plataformas de donación externas.

**Plataformas recomendadas:**

| Plataforma | URL | Ventajas |
|------------|-----|----------|
| Ko-fi (Principal) | `https://ko-fi.com/devdoblea` | Sin comisiones, simple |
| PayPal.me (Alternativa) | `https://paypal.me/devdoblea` | Directo, sin intermediario |
| GitHub Sponsors (Opcional) | `https://github.com/sponsors/DevDoblea` | Integrado con GitHub |

**Configuración necesaria:**
- Crear cuenta en Ko-fi
- Configurar página con branding de Arteria Fit
- Crear enlace PayPal.me si no existe

### REQ-017-2 — Crear DonationConstants

El sistema DEBE tener constantes para URLs de donación.

**Archivo:** `lib/core/constants/donation_constants.dart`

```dart
class DonationConstants {
  static const String kofiUrl = 'https://ko-fi.com/devdoblea';
  static const String paypalUrl = 'https://paypal.me/devdoblea';
  static const String githubSponsorsUrl = 'https://github.com/sponsors/DevDoblea';

  // Configuración de "Aha Moments"
  static const int showAfterCompletedSessions = 7;
  static const int showAfterHistoryRecords = 20;
  static const int minDaysBetweenPrompts = 30;

  static const String donationTitle = 'Apoya el desarrollo';
  static const String donationMessage = 'Si Arteria Fit te ha sido útil...';
}
```

### REQ-017-3 — Crear DonationService

El sistema DEBE tener un servicio para gestionar lógica de donaciones.

**Archivo:** `lib/core/services/donation_service.dart`

**SharedPreferences Keys:**

| Clave | Tipo | Default | Descripción |
|-------|------|---------|-------------|
| `donation_dismissed_count` | int | 0 | Veces descartado |
| `donation_last_shown` | String | null | ISO timestamp última muestra |
| `donation_made` | bool | false | Si donó (self-reported) |
| `donation_consent` | bool | false | Consentimiento para mostrar |

**Métodos requeridos:**
- `Future<bool> shouldShowDonationPrompt()`
- `Future<void> markDonationPromptShown()`
- `Future<void> markDonationDismissed()`
- `Future<List<AhaMoment>> getAhaMoments()`
- `Future<void> openDonationUrl(DonationPlatform platform)`
- `Future<void> markAsDonor()`

### REQ-017-4 — Crear DonationSheet Widget

El sistema DEBE mostrar un bottom sheet para solicitar donación.

**Archivo:** `lib/widgets/donation_sheet.dart`

**Diseño UX:**

```
┌─────────────────────────────────────────────┐
│           ☕ Apoya el Desarrollo              │
├─────────────────────────────────────────────┤
│  Si Arteria Fit te ha sido útil...           │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  🎯 Ko-fi (Recomendado)              │   │
│  │  Sin comisiones, apoyo directo      │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │  💳 PayPal                           │   │
│  │  Pago directo                        │   │
│  └─────────────────────────────────────┘   │
│                                             │
│        [Quizás más tarde]                   │
└─────────────────────────────────────────────┘
```

### REQ-017-5 — Implementar "Aha Moments"

El sistema DEBE mostrar sugerencias de donación en momentos específicos.

**Ubicaciones:**

| Ubicación | Trigger | Condición |
|-----------|---------|-----------|
| `bp_session_screen.dart` | Completar sesión | Sesión #7 exactamente |
| `bp_history_screen.dart` | Ver historial | 20+ registros |
| `settings_screen.dart` | Manual | Siempre disponible |

**Rate Limiting:**
- No mostrar más de una vez cada 30 días
- Registrar cada vez que se muestra

### REQ-017-6 — Añadir Sección en Settings

El sistema DEBE añadir acceso manual a donaciones en Settings.

**Archivo:** `lib/features/settings/settings_screen.dart`

| Elemento | Contenido |
|----------|-----------|
| Ícono | Café (cafe.svg o similar) |
| Título | "Apoyar el desarrollo" |
| Subtexto | "Contribuir con el proyecto" |
| Badge | "Ya donaste" si `donation_made == true` |

## Acceptance Criteria

- DADO QUE el usuario completa la sesión #7,
  CUANDO pasan más de 30 días desde la última sugerencia,
  ENTONCES se muestra DonationSheet.

- DADO QUE el usuario presiona "Ko-fi",
  CUANDO se abre el enlace,
  ENTONCES el navegador externo abre la URL correcta.

- DADO QUE el usuario marca "Ya doné",
  CUANDO visita Settings,
  ENTONCES se muestra el badge "Ya donaste".

- DADO QUE el usuario presiona "Más tarde",
  CUANDO se descarta el sheet,
  ENTONCES se registra el dismiss y no se muestra por 30 días.

## Dependencies

**Depende de:**
- SPEC-015 (Política de Privacidad debe mencionar donaciones)
- SPEC-016 (ConsentManager - debe respetar `donation_consent`)

**Bloquea:**
- Ninguno (módulo independiente)

## Technical Notes

### Comparación con Tip Jar IAP Original

| Aspecto | Tip Jar Original | Donación GitHub Release |
|---------|------------------|-------------------------|
| Método de pago | In-App Purchase | Enlace externo |
| Comisiones | 15-30% tienda | 0% (Ko-fi) |
| Requisito cuenta tienda | Sí | No |
| UX | Integrada | Externa (navegador) |
| Persistencia transacción | Tienda | Self-reported |
| Complejidad | Media | Baja |

### Auto-reporte de Donaciones

Como no hay integración con tienda, las donaciones son "self-reported":
- El usuario debe indicar manualmente que donó
- El badge "Ya doné" es puramente cosmético
- Considerar mostrar animación de agradecimiento

### Estructura de Archivos

```
lib/
├── core/
│   └── services/
│       └── donation_service.dart        ← NUEVO
│   └── constants/
│       └── donation_constants.dart       ← NUEVO
├── features/
│   └── settings/
│       └── settings_screen.dart          ← MODIFICAR
└── widgets/
    └── donation_sheet.dart               ← NUEVO
```

## Estimate: 8-12 hours