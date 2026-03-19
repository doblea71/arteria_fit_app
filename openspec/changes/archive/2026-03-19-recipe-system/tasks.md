## 1. Setup

- [ ] 1.1 Create `assets/data/` directory
- [ ] 1.2 Create `recipes.json` with sample recipes
- [ ] 1.3 Register asset in pubspec.yaml

## 2. Model

- [ ] 2.1 Create `lib/models/recipe_model.dart` with Recipe class
- [ ] 2.2 Implement `fromJson()` factory constructor

## 3. Service

- [ ] 3.1 Create `lib/services/recipe_service.dart`
- [ ] 3.2 Implement `loadRecipes()` method
- [ ] 3.3 Implement `groupByCategory()` method
- [ ] 3.4 Add error handling for JSON loading

## 4. Widgets

- [ ] 4.1 Create `lib/widgets/recipe_card.dart` with icon, name, description
- [ ] 4.2 Create `lib/widgets/recipe_detail_sheet.dart` BottomSheet

## 5. Screen

- [ ] 5.1 Create `lib/screens/recipes_screen.dart` with TabBar/TabBarView
- [ ] 5.2 Implement async loading with FutureBuilder
- [ ] 5.3 Show error state if JSON fails to load
- [ ] 5.4 Add tabs only for categories with recipes

## 6. Navigation

- [ ] 6.1 Add FAB to `nutrition_screen.dart`
- [ ] 6.2 Navigate to RecipesScreen on FAB tap

## 7. Verification

- [ ] 7.1 Run flutter analyze
- [ ] 7.2 Test recipes load correctly
- [ ] 7.3 Test tab navigation
- [ ] 7.4 Test recipe detail BottomSheet
- [ ] 7.5 Test Light/Dark theme consistency
