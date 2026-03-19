## Why

La pantalla de nutrición muestra alimentos saludables pero no ofrece recetas para prepararlos. Los usuarios necesitan ideas prácticas de cómo incorporar estos alimentos en su dieta diaria.

## What Changes

- Crear archivo JSON `assets/data/recipes.json` como fuente de datos de recetas
- Crear modelo `Recipe` en `lib/models/recipe_model.dart`
- Crear servicio `RecipeService` para cargar y procesar el JSON
- Crear `RecipesScreen` con TabBar por categoría de alimento
- Crear `RecipeCard` widget para mostrar recetas en lista
- Crear `RecipeDetailSheet` BottomSheet para ver detalle de receta
- Añadir FAB en `nutrition_screen.dart` para navegar a recetas
- Registrar asset en `pubspec.yaml`
- Soportar extensibilidad: agregar recetas solo modificando el JSON

## Capabilities

### New Capabilities

- **recipe-system**: Sistema de recetas alimenticias basadas en JSON, distribuibles sin tocar código

### Modified Capabilities

- **nutrition-content**: Añadir navegación a pantalla de recetas desde nutrition_screen

## Impact

- **Archivos nuevos**: `lib/models/recipe_model.dart`, `lib/services/recipe_service.dart`, `lib/screens/recipes_screen.dart`, `lib/widgets/recipe_card.dart`, `lib/widgets/recipe_detail_sheet.dart`, `assets/data/recipes.json`
- **Archivos modificados**: `pubspec.yaml`, `lib/features/nutrition/nutrition_screen.dart`
- **Dependencias nuevas**: Ninguna
- **Breaking changes**: Ninguno
