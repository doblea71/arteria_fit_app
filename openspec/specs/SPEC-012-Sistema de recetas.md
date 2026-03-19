# SPEC-012 — Módulo de Recetas Alimenticias Distribuibles por JSON

## Status: Proposed

## Context

La pantalla de nutrición (`nutrition_screen.dart`) presenta alimentos
saludables definidos en `nutrition_data.dart`. Se requiere complementar
esta información con recetas relacionadas a esos alimentos, diseñadas
para ser distribuibles y actualizables de forma independiente al código
fuente de la app, utilizando un archivo JSON como fuente de datos.
El sistema debe ser extensible: agregar nuevas recetas en futuras
versiones debe requerir únicamente modificar el archivo JSON,
sin tocar código Dart.

## Requirements

### REQ-012-1 — Archivo JSON como única fuente de datos de recetas

Las recetas DEBEN almacenarse en un archivo JSON ubicado en los
assets de la app (`assets/data/recipes.json`). Este archivo es
la única fuente de verdad para las recetas; no se hardcodean
recetas en ningún archivo Dart.

### REQ-012-2 — Estructura del archivo JSON

El archivo `recipes.json` DEBE seguir la siguiente estructura 
canónica (corrigiendo la estructura sugerida para ser JSON válido):

```json
{
  "recetas": [
    {
      "id": "recipe_001",
      "food_category": "platano",
      "name": "Receta de Plátano Asado",
      "description": "Receta ideal para las cenas livianas.",
      "icon": "🍌",
      "ingredientes": [
        "1 plátano maduro",
        "1 cucharada de aceite de oliva",
        "Canela al gusto"
      ],
      "modo_preparacion": [
        "Precalentar el air fryer a 180°C.",
        "Pelar el plátano y cortarlo en rodajas.",
        "Añadir aceite de oliva y canela.",
        "Cocinar 8 minutos hasta dorar."
      ]
    }
  ]
}
```

Campos obligatorios por receta:
| Campo | Tipo | Descripción |

|---|---|---|
| `id` | String | Identificador único de la receta |
| `food_category` | String | Clave que vincula la receta con un alimento de `nutrition_data.dart` |
| `name` | String | Nombre de la receta |
| `description` | String | Descripción breve |
| `icon` | String | Emoji o nombre de icono alegórico |
| `ingredientes` | Array\<String\> | Lista de ingredientes |
| `modo_preparacion` | Array\<String\> | Pasos de preparación ordenados |

El campo `description` es opcional pero recomendado.

### REQ-012-3 — Punto de acceso: botón flotante en nutrition_screen.dart

La pantalla `nutrition_screen.dart` DEBE incluir un
`FloatingActionButton` con la etiqueta "Recetas" y un ícono
alegórico (ej. `Icons.menu_book` o `Icons.restaurant_menu`)
que al ser presionado navegue a la pantalla `RecipesScreen`.

### REQ-012-4 — Pantalla RecipesScreen con pestañas por alimento

La pantalla `RecipesScreen` DEBE mostrar un sistema de pestañas
(`TabBar` + `TabBarView`) donde cada pestaña corresponde a un
alimento de `nutrition_data.dart` que tenga al menos una receta
asociada en el JSON. Los alimentos sin recetas NO deben generar
pestañas vacías.

### REQ-012-5 — Cards de receta dentro de cada pestaña

Dentro de cada `TabBarView`, el sistema DEBE mostrar una lista
de cards (`RecipeCard`), uno por receta vinculada a ese alimento,
con los siguientes elementos visibles:

- Ícono/emoji del alimento o la receta.
- Nombre de la receta.
- Descripción breve (truncada a 2 líneas si es larga).

### REQ-012-6 — Vista de detalle de receta

Al hacer tap en un `RecipeCard`, el sistema DEBE mostrar la
vista de detalle de la receta. La implementación DEBE usar
un `BottomSheet` modal (preferido por ser menos disruptivo)
o una pantalla de navegación completa. La vista de detalle DEBE
mostrar:

- Nombre de la receta.
- Descripción completa.
- Lista de ingredientes con viñetas.
- Pasos de preparación numerados.

### REQ-012-7 — Carga asíncrona del JSON

El JSON DEBE cargarse de forma asíncrona desde los assets usando
`rootBundle.loadString()`. Mientras se carga, DEBE mostrarse un
indicador de progreso. Si la carga falla, DEBE mostrarse un
mensaje de error informativo sin crashear la app.

### REQ-012-8 — Extensibilidad: agregar recetas sin tocar código

Agregar nuevas recetas en futuras versiones DEBE requerir
únicamente: añadir un nuevo objeto al array `recetas` del JSON
y actualizar la app con el nuevo asset. Ningún archivo Dart debe
ser modificado para agregar recetas.

### REQ-012-9 — Consistencia con tema Light/Dark

Todos los widgets nuevos (`RecipesScreen`, `RecipeCard`,
vista de detalle) DEBEN respetar el ThemeProvider de la app
(ver SPEC-002), sin colores hardcoded.

## Acceptance Criteria

- DADO QUE el usuario está en nutrition_screen.dart,
  CUANDO visualiza la pantalla,
  ENTONCES ve un FloatingActionButton con la etiqueta "Recetas"
  visible sin desplazarse.

- DADO QUE el usuario pulsa el FAB "Recetas",
  CUANDO se navega a RecipesScreen,
  ENTONCES ve pestañas únicamente para alimentos con recetas
  disponibles en el JSON.

- DADO QUE el JSON contiene 3 recetas para "Plátano" y 2 para "Aguacate",
  CUANDO el usuario abre la pestaña "Plátano",
  ENTONCES ve exactamente 3 cards de receta.

- DADO QUE el usuario hace tap en un RecipeCard,
  CUANDO se abre la vista de detalle,
  ENTONCES ve el nombre, descripción, ingredientes en lista
  y pasos de preparación numerados.

- DADO QUE se agrega una nueva receta al JSON sin tocar código Dart,
  CUANDO se actualiza y ejecuta la app,
  ENTONCES la nueva receta aparece en la pestaña correspondiente
  sin ningún cambio en los archivos .dart.

- DADO QUE el JSON no puede cargarse por error de asset,
  CUANDO se abre RecipesScreen,
  ENTONCES se muestra un mensaje de error sin crashear la app.

- DADO QUE la app está en modo Dark,
  CUANDO el usuario visualiza los cards de receta,
  ENTONCES los colores son consistentes con el tema Dark.

## Technical Notes

### Estructura de archivos nuevos

```
lib/
  models/
    recipe_model.dart          ← Modelo de datos: clase Recipe
  services/
    recipe_service.dart        ← Carga y parseo del JSON
  screens/
    recipes_screen.dart        ← TabBar principal
  widgets/
    recipe_card.dart           ← Card individual de receta
    recipe_detail_sheet.dart   ← BottomSheet de detalle

assets/
  data/
    recipes.json               ← ÚNICA fuente de recetas
```

### Modelo de datos sugerido

```dart
class Recipe {
  final String id;
  final String foodCategory;
  final String name;
  final String description;
  final String icon;
  final List<String> ingredientes;
  final List<String> modoPreparacion;

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json['id'],
    foodCategory: json['food_category'],
    name: json['name'],
    description: json['description'] ?? '',
    icon: json['icon'] ?? '🍽️',
    ingredientes: List<String>.from(json['ingredientes']),
    modoPreparacion: List<String>.from(json['modo_preparacion']),
  );
}
```

### Servicio de carga sugerido

```dart
class RecipeService {
  Future<List<Recipe>> loadRecipes() async {
    final String jsonString = await rootBundle
        .loadString('assets/data/recipes.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    return (data['recetas'] as List)
        .map((r) => Recipe.fromJson(r))
        .toList();
  }

  Map<String, List<Recipe>> groupByCategory(List<Recipe> recipes) {
    final Map<String, List<Recipe>> grouped = {};
    for (final r in recipes) {
      grouped.putIfAbsent(r.foodCategory, () => []).add(r);
    }
    return grouped;
  }
}
```

### Registro del asset en pubspec.yaml

```yaml
flutter:
  assets:
    - assets/data/recipes.json
```

### Archivos afectados / creados

- `pubspec.yaml` (registro del asset)
- `assets/data/recipes.json` (nuevo)
- `lib/models/recipe_model.dart` (nuevo)
- `lib/services/recipe_service.dart` (nuevo)
- `lib/screens/recipes_screen.dart` (nuevo)
- `lib/widgets/recipe_card.dart` (nuevo)
- `lib/widgets/recipe_detail_sheet.dart` (nuevo)
- `lib/screens/nutrition_screen.dart` (agregar FAB)

## Dependencias

- SPEC-002 debe estar implementado para garantizar consistencia
  de tema en los widgets nuevos.
- Sin dependencia con SPEC-004, SPEC-005 ni otros SPECs de ejercicio.
