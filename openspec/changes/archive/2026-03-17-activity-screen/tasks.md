## 1. Database Service

- [x] 1.1 Add getAllLogs() method to DatabaseService that returns all exercise logs
- [x] 1.2 Verify DatabaseService is properly implemented (SPEC-004)

## 2. Activity Screen Implementation

- [x] 2.1 Create ActivityScreen widget with ListView.builder
- [x] 2.2 Implement exercise item card with type icon, date/time, duration
- [x] 2.3 Add visual differentiation (icons/colors) for breathing vs isometric
- [x] 2.4 Implement empty state when no exercises exist
- [x] 2.5 Ensure theme consistency (Light/Dark mode support)

## 3. Router & Navigation

- [x] 3.1 Add ActivityScreen route in app_router.dart
- [x] 3.2 Connect BottomNavigationBar to navigate to Activity screen
- [x] 3.3 Test navigation works correctly

## 4. Verification

- [x] 4.1 Test with exercises - verify chronological order (most recent first)
- [x] 4.2 Test empty state - verify friendly message shows when no exercises
- [x] 4.3 Test theme - verify Light/Dark mode works correctly
- [x] 4.4 Run lint/typecheck to ensure code quality (1 pre-existing warning in database_service.dart)
