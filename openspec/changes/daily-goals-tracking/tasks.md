## 1. Dependencias

- [x] 1.1 Agregar `sqflite` a pubspec.yaml
- [x] 1.2 Agregar `path_provider` a pubspec.yaml
- [x] 1.3 Ejecutar `flutter pub get`

## 2. DatabaseService

- [x] 2.1 Crear `lib/core/services/database_service.dart`
- [x] 2.2 Implementar método `initDatabase()` para crear tablas
- [x] 2.3 Implementar método `insertExerciseLog()` para registrar ejercicios
- [x] 2.4 Implementar método `getLogsToday()` para obtener ejercicios de hoy
- [x] 2.5 Implementar método `getDailyGoal()` para obtener meta diaria
- [x] 2.6 Implementar método `setDailyGoal()` para guardar meta diaria

## 3. Pantalla Ajustes (Settings)

- [x] 3.1 Crear `lib/features/settings/settings_screen.dart`
- [x] 3.2 Crear formulario para configurar meta diaria de respiración
- [x] 3.3 Crear formulario para configurar meta diaria de isométricos
- [x] 3.4 Guardar metas en SQLite al confirmar

## 4. Modificar Breathing Screen

- [x] 4.1 Importar DatabaseService en breathing_screen.dart
- [x] 4.2 Llamar `insertExerciseLog()` al completar ejercicio

## 5. Modificar Isometrics Screen

- [x] 5.1 Importar DatabaseService en isometrics_screen.dart
- [x] 5.2 Llamar `insertExerciseLog()` al completar todos los sets

## 6. Modificar Dashboard

- [x] 6.1 Importar DatabaseService en dashboard_screen.dart
- [x] 6.2 Cargar ejercicios completados hoy al iniciar
- [x] 6.3 Cargar metas diarias al iniciar
- [x] 6.4 Actualizar buildProgressCard() para mostrar datos reales

## 7. Navegación

- [x] 7.1 Agregar ruta en app_router.dart para Settings
- [x] 7.2 Conectar BottomNavigationBar al índice de Ajustes
- [x] 7.3 Navegar a Settings al hacer tap en icono de ajustes

## 8. Verificación

- [x] 8.1 Ejecutar `flutter analyze` para verificar errores
- [ ] 8.2 Probar registro de ejercicio de respiración
- [ ] 8.3 Probar registro de ejercicio isométrico
- [ ] 8.4 Probar cambio de metas en Ajustes
- [ ] 8.5 Verificar que dashboard muestra progreso correcto
