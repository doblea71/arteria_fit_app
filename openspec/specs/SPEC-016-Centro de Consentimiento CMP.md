# SPEC-016 — Centro de Consentimiento CMP (Módulo 3)

## Status: Proposed

## Context

El Centro de Consentimiento (CMP - Consent Management Platform) es el primer módulo de monetización que debe implementarse. Es un prerequisito para los módulos de monetización pasiva y donaciones.

La implementación es **100% Flutter**, sin código nativo, lo que lo hace técnicamente viable.

**Depende de:** SPEC-015 (Infraestructura Legal)

## Requirements

### REQ-016-1 — Crear ConsentManager Service

El sistema DEBE tener un servicio para gestionar todas las preferencias de consentimiento.

**Archivo:** `lib/core/services/consent_manager.dart`

**SharedPreferences Keys:**

| Clave | Tipo | Default | Descripción |
|-------|------|---------|-------------|
| `onboarding_privacy_completed` | bool | false | ¿Completó el onboarding? |
| `tip_jar_consent` | bool | false | ¿Aceptó donaciones? |
| `passive_monetization_consent_given` | bool | false | ¿Aceptó monetización pasiva? |
| `passive_monetization_enabled` | bool | false | ¿Toggle activo? |
| `consent_timestamp` | String | null | ISO timestamp |

**Métodos requeridos:**
- `Future<bool> hasCompletedOnboarding()`
- `Future<void> completeOnboarding({required bool tipJarConsent, required bool passiveMonetizationConsent})`
- `Future<Map<String, bool>> getAllConsents()`
- `Future<void> updateConsent(String key, bool value)`
- `Future<void> deleteAllUserData()`
- `Future<Map<String, dynamic>> exportUserData()`

### REQ-016-2 — Implementar PrivacyOnboardingScreen

El sistema DEBE mostrar una pantalla de onboarding de privacidad (3 páginas) en la primera ejecución.

**Archivo:** `lib/screens/onboarding/privacy_onboarding_screen.dart`

| Página | Título | Contenido | Acción |
|--------|--------|-----------|--------|
| 1 | "Bienvenido" | Introducción, datos almacenados localmente | Botón "Continuar" |
| 2 | "Apoya el desarrollo" | Tip Jar y monetización pasiva con checkboxes opt-in | Botones "Continuar" / "Más tarde" |
| 3 | "Tus derechos" | Derechos RGPD + links a Política y Términos | Botón "Entendido" |

**Widgets:**
- PageView para navegación entre páginas
- Indicador de progreso (dots)
- Checkboxes para consentimientos opcionales
- Links a URLs de SPEC-015

### REQ-016-3 — Integrar Onboarding en Flujo de Inicio

El sistema DEBE modificar el flujo de inicio para mostrar el onboarding de privacidad solo la primera vez.

**Flujo:**
```
Inicio App
    ├─ ¿onboarding_privacy_completed == true?
    │       ├─ SÍ → Continuar flujo normal
    │       └─ NO → Mostrar PrivacyOnboardingScreen
    │                    └─ Al completar → Guardar consentimientos
    │                                      → Continuar flujo normal
```

### REQ-016-4 — Añadir Sección "Privacidad y Apoyo" en Settings

El sistema DEBE añadir una sección de privacidad en la pantalla de ajustes.

**Archivo:** `lib/features/settings/settings_screen.dart`

| Elemento | Tipo | Descripción |
|----------|------|-------------|
| Política de Privacidad | Link | Abre URL de SPEC-015 |
| Términos de Uso | Link | Abre URL de SPEC-015 |
| Estado del consentimiento | Texto | Muestra consentimientos activos |
| Eliminar todos mis datos | Botón | Acción destructiva con confirmación |
| Exportar mis datos | Botón | Exporta datos en JSON (portabilidad RGPD) |

### REQ-016-5 — Implementar Eliminación de Datos

El sistema DEBE permitir eliminar todos los datos del usuario con doble confirmación.

**UX:**
1. Usuario presiona "Eliminar todos mis datos"
2. Diálogo: "Esta acción no se puede deshacer. ¿Estás seguro?"
3. Si confirma: Diálogo final: "Escribe 'ELIMINAR' para confirmar"
4. Proceso de eliminación con indicador de progreso
5. App se reinicia mostrando el onboarding de privacidad

**Eliminación incluye:**
- SharedPreferences (clear)
- Base de datos local (deleteAll)
- Archivos locales (getApplicationDocumentsDirectory)

## Acceptance Criteria

- DADO QUE es la primera ejecución de la app,
  CUANDO el usuario inicia la app,
  ENTONCES se muestra PrivacyOnboardingScreen.

- DADO QUE el usuario completó el onboarding,
  CUANDO inicia la app nuevamente,
  ENTONCES NO se muestra PrivacyOnboardingScreen.

- DADO QUE el usuario solicita eliminar sus datos,
  CUANDO confirma con doble verificación,
  ENTONCES todos los datos locales se eliminan y la app se reinicia.

- DADO QUE el usuario quiere exportar sus datos,
  CUANDO presiona "Exportar mis datos",
  ENTONCES se genera un archivo JSON descargable.

## Dependencies

**Depende de:**
- SPEC-015 (URLs de documentos legales)

**Bloquea:**
- SPEC-017 (Sistema de Donaciones)
- SPEC-018 (Investigación Infatica)

## Technical Notes

### Cumplimiento RGPD

| Artículo | Requisito | Implementación |
|----------|-----------|----------------|
| Art. 7 | Consentimiento libre, específico e informado | Onboarding con información clara |
| Art. 7(3) | Consentimiento revocable | Toggle en Settings |
| Art. 13 | Información sobre tratamiento | Links a Política de Privacidad |
| Art. 17 | Derecho al olvido | Botón "Eliminar todos mis datos" |
| Art. 20 | Derecho a portabilidad | Botón "Exportar mis datos" |

### Estructura de Archivos

```
lib/
├── core/
│   ├── constants/
│   │   └── legal_constants.dart      ← SPEC-015
│   └── services/
│       └── consent_manager.dart      ← NUEVO
├── features/
│   └── settings/
│       └── settings_screen.dart      ← MODIFICAR
├── screens/
│   └── onboarding/
│       └── privacy_onboarding_screen.dart  ← NUEVO
└── widgets/
    └── consent_toggle.dart            ← NUEVO
```

## Estimate: 6-10 hours