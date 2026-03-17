## Context

El modelo `NutritionData` en `lib/shared/models/nutrition_data.dart` contiene un FoodItem con nombre "Semillas de Sandía" que debería ser "Semillas de Calabaza". El ícono actual es 🍉 (watermelon) pero debería representar calabaza.

## Goals / Non-Goals

**Goals:**
- Corregir el nombre del FoodItem de "Semillas de Sandía" a "Semillas de Calabaza"
- Cambiar el ícono de 🍉 a uno que represente calabaza

**Non-Goals:**
- No modificar otros FoodItems
- No añadir nuevos alimentos

## Decisions

### DECISIÓN 1: Usar ícono 🎃 (jack-o-lantern) para calabaza

**Alternativa considerada**: Usar un emoji de semilla genérico o texto
**Rationale**: 🎃 es universalmente reconocido como calabaza y está disponible en todos los dispositivos

## Risks / Trade-offs

- **[Riesgo]**: Ninguno - es un cambio simple de texto e ícono

## Migration Plan

1. Modificar `lib/shared/models/nutrition_data.dart`
2. Cambiar nombre de "Semillas de Sandía" a "Semillas de Calabaza"
3. Cambiar ícono de 🍉 a 🎃

## Open Questions

- Ninguno
