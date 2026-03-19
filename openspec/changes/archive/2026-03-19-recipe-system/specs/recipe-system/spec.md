## ADDED Requirements

### Requirement: Archivo JSON como fuente de datos de recetas
Las recetas DEBEN almacenarse en `assets/data/recipes.json`. Este archivo es la única fuente de verdad.

#### Scenario: Recetas cargadas desde JSON
- **WHEN** RecipeService carga recetas
- **THEN** las recetas se leen del archivo JSON en assets

### Requirement: FAB en nutrition_screen para navegar a recetas
La pantalla nutrition_screen DEBE incluir un FloatingActionButton "Recetas" que navegue a RecipesScreen.

#### Scenario: FAB visible en nutrition
- **WHEN** el usuario está en nutrition_screen
- **THEN** ve un FAB con ícono de menú/libro

### Requirement: RecipesScreen con pestañas por alimento
RecipesScreen DEBE mostrar TabBar con pestañas para cada alimento que tenga recetas.

#### Scenario: Pestañas solo para alimentos con recetas
- **WHEN** se abre RecipesScreen
- **THEN** las pestañas corresponden solo a alimentos con recetas en el JSON

### Requirement: RecipeCard muestra nombre, ícono y descripción
Cada RecipeCard DEBE mostrar: ícono/emoji, nombre de receta, descripción truncada a 2 líneas.

#### Scenario: Card muestra información de receta
- **WHEN** se muestra un RecipeCard
- **THEN** ve ícono, nombre y descripción

### Requirement: BottomSheet de detalle de receta
Al tapear RecipeCard, DEBE mostrarse BottomSheet con: nombre, descripción, ingredientes en lista, pasos numerados.

#### Scenario: Detalle muestra información completa
- **WHEN** usuario toca RecipeCard
- **THEN** ve BottomSheet con todos los detalles de la receta

### Requirement: Carga asíncrona con indicador de progreso
El JSON DEBE cargarse asíncronamente. Mientras carga DEBE mostrarse CircularProgressIndicator.

#### Scenario: Indicador mientras carga
- **WHEN** RecipesScreen se abre y el JSON aún no ha cargado
- **THEN** ve un indicador de progreso

### Requirement: Manejo de errores en carga de JSON
Si la carga falla, DEBE mostrarse mensaje de error sin crashear la app.

#### Scenario: Error al cargar JSON
- **WHEN** el archivo JSON no puede cargarse
- **THEN** se muestra mensaje de error informativo

### Requirement: Consistencia con tema Light/Dark
Todos los widgets DEBEN respetar ThemeProvider de la app.

#### Scenario: Modo Dark
- **WHEN** la app está en modo Dark
- **THEN** RecipesScreen usa colores del tema Dark

### Requirement: Extensibilidad sin modificar código
Agregar recetas DEBE requerir solo modificar el JSON.

#### Scenario: Nueva receta aparece sin cambios en código
- **WHEN** se añade una receta al JSON
- **THEN** aparece automáticamente en la app sin modificar archivos .dart
