## Context

SPEC-018 requiere investigar Infatica SDK para monetización pasiva P2B. La especificación original propuso este SDK pero hay muchas incógnitas sobre su viabilidad técnica y legal.

**Fase obligatoria de investigación antes de cualquier implementación.**

## Goals / Non-Goals

**Goals:**
- Determinar si Infatica ofrece SDK móvil viable
- Evaluar alternativas si Infatica no es viable
- Documentar decisión formal con criterios claros
- Decidir si proceder a Fase 2 (implementación)

**Non-Goals:**
- NO implementar nada hasta que investigación esté completa
- NO asumir que Infatica es la solución correcta
- NO proceder con implementación si hay riesgos inaceptables

## Decisions

### DEC-1: Investigación estructurada en fases

**Decisión:** Separar investigación de implementación en dos fases distintas.

**Rationale:** Evita implementación Prematura de características no probadas. Permite tomar decisiones informadas.

### DEC-2: Criterios de rechazo formales

**Decisión:** Definir criterios objetivos para rechazar el módulo si no es viable.

**Criterios de rechazo:**
- No hay SDK móvil disponible
- Términos incompatibles con RGPD
- Impacto en batería/rendimiento inaceptable
- Modelo de ingresos no viable
- No hay forma de obtener API keys

### DEC-3: Documento de decisión formal

**Decisión:** Crear `docs/DECISION_MONETIZACION_PASIVA.md` con estructura formal.

**Contenido:**
1. Resumen ejecutivo
2. Investigación realizada
3. Opciones evaluadas
4. Criterios de evaluación
5. Decisión final
6. Justificación
7. Próximos pasos

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| SDK no disponible para Flutter | Evaluar alternativas nativas con MethodChannel |
| Rechazo de App Store | Documentar riesgo, considerar solo Android inicialmente |
| Problemas RGPD | Rechazar si términos son incompatibles |
| Impacto en batería | Implementar restricciones estrictas (Wi-Fi + batería > 50%) |
| Modelo de ingresos bajo | Aceptar como bonus, no dependencia |

## Open Questions

1. ¿Infatica realmente ofrece SDK móvil o es solo proxy web?
2. ¿Honeygain/PacketStream son alternativas viables?
3. ¿Qué datos exactly se comparten con el usuario?
4. ¿El modelo de ingresos justifica el desarrollo?
