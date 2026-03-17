# SPEC-007 — Corrección de Contenido: Card de Semillas de Calabaza (nutrition_screen.dart)

## Status: Proposed

## Context

Al final de la pantalla de nutrición existe un Card que describe las "Semillas de 
Sandía", siendo incorrecto. El contenido corresponde a las Semillas de Calabaza.

## Requirements

### REQ-007-1 — Corrección del texto del Card

El texto del Card al final de la pantalla de nutrición DEBE referirse a las 
Semillas de Calabaza, no a las Semillas de Sandía.

### REQ-007-2 — Corrección del ícono del Card

El ícono del Card DEBE ser alegórico a la calabaza o a sus semillas. 
Si no existe un ícono estándar disponible en el set actual, se DEBE usar el 
ícono más representativo disponible o un asset personalizado.

## Acceptance Criteria

- DADO QUE el usuario accede a la pantalla de nutrición,
  CUANDO visualiza el último Card,
  ENTONCES el título, descripción e ícono hacen referencia a Semillas de Calabaza.

## Technical Notes

- Archivo afectado: `lib/screens/nutrition_screen.dart`.
- Revisar si existe `Icons.pumpkin` o similar; de lo contrario usar un asset SVG/PNG.
- Impacto mínimo: solo texto e ícono del último Card.
