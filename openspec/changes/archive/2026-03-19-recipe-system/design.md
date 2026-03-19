## Context

La app tiene una pantalla de nutrición que muestra alimentos saludables pero no ofrece recetas. Se necesita un sistema de recetas que sea fácil de actualizar sin modificar código fuente.

## Goals / Non-Goals

**Goals:**
- Sistema de recetas basado en JSON para extensibilidad
- Pantalla de recetas con pestañas por categoría de alimento
- Detalle de receta en BottomSheet modal
- Consistencia con tema Light/Dark
- Carga asíncrona con manejo de errores

**Non-Goals:**
- No implementar búsqueda o filtrado de recetas
- No implementar favoritos o guardar recetas
- No implementar分享 de recetas

## Decisions

### DECISIÓN 1: Usar JSON en assets en lugar de API o Base64

**Alternativa considerada**: API REST o datos codificados en Base64
**Rationale**: JSON en assets es simple, no requiere backend, y se actualiza con cada versión de la app

### DECISIÓN 2: BottomSheet para detalle en lugar de pantalla completa

**Alternativa considerada**: Navegación a nueva pantalla
**Rationale**: BottomSheet es menos disruptivo, mantiene el contexto de la pestaña actual

### DECISIÓN 3: groupByCategory para filtrar pestañas

**Alternativa considerada**: Generar pestañas para todos los alimentos
**Rationale**: Solo mostrar pestañas con recetas, evita pestañas vacías

## Risks / Trade-offs

- **[Riesgo]**: El JSON debe estar bien formado o la app puede fallar
  - **Mitigación**: Try-catch en RecipeService con mensaje de error amigable

## Migration Plan

1. Crear directorio `assets/data/`
2. Crear `recipe_model.dart` con clase Recipe
3. Crear `recipe_service.dart` con carga y groupBy
4. Crear `recipes_screen.dart` con TabBar
5. Crear `recipe_card.dart` widget
6. Crear `recipe_detail_sheet.dart` BottomSheet
7. Añadir FAB a `nutrition_screen.dart`
8. Registrar asset en pubspec.yaml
9. Crear sample `recipes.json`

## Open Questions

- ¿Cuántas recetas incluir en el JSON inicial?
