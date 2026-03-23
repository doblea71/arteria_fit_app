# SPEC-018 — Investigación e Integración Infatica SDK (Módulo 2)

## Status: Proposed - Requiere Investigación Previa

## Context

El análisis original propone usar el SDK de Infatica para monetización pasiva P2B. Sin embargo, existen **incógnitas críticas**:

1. **No sabemos qué es Infatica** - ¿Es un proveedor de SDK móvil?
2. **No sabemos si requiere cuenta** - ¿Cómo se obtienen API keys?
3. **No conocemos los términos** - ¿Cumple con RGPD?
4. **No hay documentación** - ¿Cómo se integra el SDK?

**⚠️ Este SPEC tiene dos fases obligatorias:**
- **Fase 1:** Investigación (obligatoria antes de implementar)
- **Fase 2:** Implementación (solo si la investigación es positiva)

**Depende de:** SPEC-015, SPEC-016

## Fase 1: Investigación (Obligatoria)

### REQ-018-1 — Investigar Infatica

El equipo DEBE investigar exhaustivamente qué es Infatica y si es viable.

**Preguntas a responder:**

| Pregunta | Estado |
|----------|--------|
| ¿Qué es Infatica? | Pendiente |
| ¿Ofrecen SDK móvil? | Pendiente |
| ¿Hay SDK para Flutter/Dart? | Pendiente |
| ¿Requieren registro de cuenta? | Pendiente |
| ¿Cómo se obtienen API keys? | Pendiente |
| ¿Cuál es el modelo de ingresos? | Pendiente |
| ¿Hay SDK nativo para Android? | Pendiente |
| ¿Hay SDK nativo para iOS? | Pendiente |
| ¿Qué datos comparten los usuarios? | Pendiente |
| ¿Cumplen con RGPD? | Pendiente |
| ¿Tienen documentación pública? | Pendiente |

**Pasos:**
1. Búsqueda web: "Infatica SDK mobile", "Infatica Flutter"
2. Visitar sitio oficial y revisar documentación
3. Investigar alternativas: Honeygain SDK, PacketStream, etc.
4. Buscar en foros experiencias de desarrolladores
5. Buscar en GitHub repositorios que usen Infatica

**Criterio para continuar a Fase 2:**
- [ ] SDK móvil disponible
- [ ] Documentación técnica accesible
- [ ] Proceso claro de registro/API keys
- [ ] Términos compatibles con RGPD
- [ ] Modelo de ingresos viable

### REQ-018-2 — Evaluar Alternativas

El equipo DEBE documentar al menos 2 alternativas si Infatica no es viable.

**Alternativas potenciales:**

| Proveedor | Tipo | Estado |
|-----------|------|--------|
| Honeygain | SDK para compartir ancho de banda | Investigar |
| PacketStream | Similar a Honeygain | Investigar |
| TraffMonetizer | Monetización de tráfico | Investigar |
| Proxy SDK genérico | Varios proveedores | Investigar |
| SDK de anuncios | AdMob, etc. | Opción alternativa |

### REQ-018-3 — Documentar Decisión

El equipo DEBE crear un documento de decisión técnica.

**Archivo:** `docs/DECISION_MONETIZACION_PASIVA.md`

**Contenido:**
- Resumen de la decisión
- Investigación realizada
- Opciones evaluadas
- Decisión final (Implementar / No implementar)
- Justificación
- Próximos pasos

## Fase 2: Implementación (Condicional)

**⚠️ SOLO proceder si la Fase 1 confirma viabilidad.**

### REQ-018-4 — Integrar SDK (Si aplica)

El sistema DEBE integrar el SDK seleccionado según documentación.

**Pasos:**
1. Añadir dependencia en `pubspec.yaml` (si hay paquete Flutter)
2. O implementar MethodChannel con código nativo
3. Configurar API keys
4. Implementar inicialización

**Si requiere código nativo:**

**Android:** `android/app/src/main/kotlin/PassiveMonetizationChannel.kt`
**iOS:** `ios/Runner/PassiveMonetizationChannel.swift`

### REQ-018-5 — Implementar PassiveMonetizationService

El sistema DEBE tener un servicio Flutter para gestionar monetización pasiva.

**Archivo:** `lib/core/services/passive_monetization_service.dart`

**Métodos:**
- `Future<void> initialize(String apiKey)`
- `Future<bool> isActive()`
- `Future<void> enable()`
- `Future<void> disable()`
- `Future<bool> canRunSafely()` - Verifica Wi-Fi y batería
- `Future<MonetizationStats> getStats()`

### REQ-018-6 — Implementar PassiveSupportToggle

El sistema DEBE mostrar un toggle en Settings para activar/desactivar.

**Archivo:** `lib/widgets/passive_support_toggle.dart`

**UX:**

```
┌─────────────────────────────────────────────┐
│  📡 Apoyo pasivo                            │
├─────────────────────────────────────────────┤
│  Comparte tu conexión inactiva para apoyar  │
│  el desarrollo de la app.                   │
│                                             │
│  Solo funciona con Wi-Fi y batería > 50%   │
│                                             │
│  [Toggle: ▬▬▬▬○] Activo                    │
│                                             │
│  Este mes: 0.00 MB compartidos              │
└─────────────────────────────────────────────┘
```

### REQ-018-7 — Implementar Restricciones

El sistema DEBE restringir el funcionamiento para proteger al usuario.

**Restricciones:**
- Solo funciona con Wi-Fi (no datos móviles)
- Solo funciona con batería > 50% o conectado a corriente
- Solo funciona cuando el dispositivo está inactivo

### REQ-018-8 — Actualizar Documentos Legales

El sistema DEBE actualizar la Política de Privacidad para incluir monetización pasiva.

**Contenido a añadir:**

```markdown
## Monetización Pasiva (si activa)

Si has activado el "Apoyo pasivo", la aplicación puede:
- Compartir parte de tu conexión de internet inactiva
- Solo cuando estás conectado a Wi-Fi
- Solo cuando tu batería está por encima del 50%

Tus datos personales nunca se comparten.
Puedes desactivar esta función en cualquier momento desde Ajustes.
```

## Acceptance Criteria

### Fase 1 (Investigación)

- DADO QUE se inicia la investigación,
  CUANDO se completan los pasos de investigación,
  ENTONCES todas las preguntas tienen respuesta documentada.

- DADO QUE Infatica no es viable,
  CUANDO se evalúan alternativas,
  ENTONCES al menos 2 alternativas están documentadas.

### Fase 2 (Implementación - Solo si Fase 1 positiva)

- DADO QUE el usuario activa el toggle,
  CUANDO está en Wi-Fi con batería > 50%,
  ENTONCES el SDK se inicializa correctamente.

- DADO QUE el usuario desactiva el toggle,
  CUANDO estaba activo,
  ENTONCES el SDK se detiene inmediatamente.

- DADO QUE el usuario quiere saber qué datos se comparten,
  CUANDO consulta la Política de Privacidad,
  ENTONCES hay una sección clara sobre monetización pasiva.

## Dependencies

**Depende de:**
- SPEC-015 (Documentos legales)
- SPEC-016 (ConsentManager - debe respetar `passive_monetization_consent`)

**Bloquea:**
- Ninguno (módulo independiente)

## Technical Notes

### Riesgos

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| SDK no disponible para móvil | Media | Alto | Investigar primero |
| Rechazo de Apple App Store | Media | Alto | Apple es estricto con apps que comparten recursos |
| Usuarios reportan uso de batería | Media | Medio | Restricciones estrictas |
| Problemas legales RGPD | Baja | Alto | Documentación clara |

### Criterio de Rechazo del Módulo

El módulo DEBE rechazarse si:
1. No hay SDK móvil disponible
2. Términos incompatibles con RGPD
3. Impacto en batería/rendimiento inaceptable
4. Modelo de ingresos no viable
5. No hay forma de obtener API keys

### Estructura de Archivos (Si se implementa)

```
lib/
├── core/
│   └── services/
│       └── passive_monetization_service.dart  ← NUEVO
├── features/
│   └── settings/
│       └── settings_screen.dart               ← MODIFICAR
└── widgets/
    └── passive_support_toggle.dart            ← NUEVO

android/app/src/main/kotlin/
└── PassiveMonetizationChannel.kt              ← NUEVO (si requiere nativo)

ios/Runner/
└── PassiveMonetizationChannel.swift           ← NUEVO (si requiere nativo)
```

## Estimate: 16-24 hours (después de investigación)

## Checklist

### Fase 1 (Investigación)
- [ ] Investigación de Infatica completada
- [ ] Alternativas evaluadas
- [ ] Documento de decisión creado
- [ ] Decisión tomada: Implementar / No implementar

### Fase 2 (Implementación - Solo si Fase 1 positiva)
- [ ] SDK integrado en Android
- [ ] SDK integrado en iOS
- [ ] PassiveMonetizationService implementado
- [ ] PassiveSupportToggle implementado
- [ ] Restricciones de Wi-Fi/batería funcionan
- [ ] Política de Privacidad actualizada
- [ ] Consentimiento respetado
- [ ] Tests en dispositivos reales