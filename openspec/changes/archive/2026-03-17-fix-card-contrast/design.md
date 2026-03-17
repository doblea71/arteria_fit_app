## Context

Los cards en las pantallas de Nutrición, Isométricos y Respiración usan colores hardcodeados:
- Fondo: `Colors.white` o `Color(0xFFF1F5F9)`
- Texto: `Colors.black` o colores fijos

Esto causa:
1. Bajo contraste en modo Light (textos grises sobre fondo blanco)
2. Pésima legibilidad en modo Dark (texto negro sobre fondo blanco)

## Goals / Non-Goals

**Goals:**
- Asegurar contraste mínimo 4.5:1 (WCAG AA) en todos los cards
- Los cards deben responder automáticamente al tema Light/Dark
- Usar colores del Theme de Flutter

**Non-Goals:**
- No cambiar la estructura de los cards
- No agregar nuevas funcionalidades

## Decisions

### DECISIÓN 1: Usar Theme.of(context).cardTheme.color

**Alternativa considerada**: Definir colores manualmente para cada tema
**Rationale**: Flutter ya tiene un sistema de temas robusto. Usar `Theme.of(context).cardTheme.color` asegura consistencia con el resto de la app.

### DECISIÓN 2: Usar Theme.of(context).colorScheme.onSurface para texto

**Alternativa considerada**: Definir colores de texto manualmente
**Rationale**: El colorScheme.onSurface automáticamente ajusta entre texto oscuro (Light) y claro (Dark), manteniendo contraste.

## Risks / Trade-offs

- **[Riesgo]**: Algunos widgets pueden tener colores de texto específicos que no se heredan
  - **Mitigación**: Verificar cada card individualmente después del cambio

## Migration Plan

1. Identificar todos los colores hardcodeados en los 3 archivos
2. Reemplazar con equivalentes de Theme.of(context)
3. Verificar que el contraste sea adecuado en ambos temas

## Open Questions

- Ninguno - la solución es directa
