## 1. Setup & Dependencies

- [x] 1.1 Add `flutter_local_notifications: ^17.2.4` to dependencies in pubspec.yaml
- [x] 1.2 Add `timezone: ^0.9.4` to dependencies in pubspec.yaml
- [x] 1.3 Add `fl_chart: ^0.69.0` to dependencies in pubspec.yaml
- [x] 1.4 Run `flutter pub get`
- [x] 1.5 Add notification permissions to AndroidManifest.xml (SCHEDULE_EXACT_ALARM, RECEIVE_BOOT_COMPLETED, receivers)
- [x] 1.6 Configure iOS notification settings in Info.plist

## 2. Database Schema

- [x] 2.1 Add `bp_protocol` table to database_service.dart
- [x] 2.2 Add `bp_session` table to database_service.dart
- [x] 2.3 Add `bp_reading` table to database_service.dart
- [x] 2.4 Add CRUD methods for bp_protocol (create, get_active, update_status, cancel)
- [x] 2.5 Add CRUD methods for bp_session (create_for_protocol, get_by_protocol, update_status, get_pending)
- [x] 2.6 Add CRUD methods for bp_reading (create, get_by_session)

## 3. Data Models

- [x] 3.1 Create `lib/models/bp_protocol_model.dart` with BpProtocol class
- [x] 3.2 Create `lib/models/bp_session_model.dart` with BpSession class
- [x] 3.3 Create `lib/models/bp_reading_model.dart` with BpReading class

## 4. Notification Service

- [x] 4.1 Create `lib/services/notification_service.dart`
- [x] 4.2 Implement `init()` method with timezone initialization
- [x] 4.3 Implement `requestPermission()` method for Android/iOS
- [x] 4.4 Implement `scheduleSessionNotification()` with 10-min advance and exact time
- [x] 4.5 Implement `scheduleAllSessions()` for 14 notifications
- [x] 4.6 Implement `cancelAll()` and `cancelByIds()` methods
- [x] 4.7 Call NotificationService.init() in main.dart

## 5. Protocol Service

- [x] 5.1 Create `lib/services/bp_protocol_service.dart`
- [x] 5.2 Implement `startProtocol()` with validation and session generation
- [x] 5.3 Implement `cancelProtocol()` with notification cancellation
- [x] 5.4 Implement `completeSession()` and `saveReading()`
- [x] 5.5 Implement `getActiveProtocol()` and `getProtocolSessions()`
- [x] 5.6 Implement `getResults()` with day 1 exclusion and averages

## 6. UI - Protocol Screen

- [x] 6.1 Create `lib/screens/bp_protocol_screen.dart`
- [x] 6.2 Display protocol status (not started / in progress / completed)
- [x] 6.3 Show time picker dialog for morning/evening times
- [x] 6.4 Validate 6-9 hour difference between sessions
- [x] 6.5 Display 7-day calendar with session status cards
- [x] 6.6 Handle confirmation dialog for active protocol replacement
- [x] 6.7 Add route to app_router.dart

## 7. UI - Session Screen

- [x] 7.1 Create `lib/screens/bp_session_screen.dart`
- [x] 7.2 Create `lib/screens/bp_recommendations_screen.dart` with checklist
- [x] 7.3 Implement 5-minute rest timer option
- [x] 7.4 Create `lib/widgets/bp_reading_input.dart` widget (integrated in session screen)
- [x] 7.5 Implement 60-second countdown timer between readings
- [x] 7.6 Add value validation with warnings (70-250, 40-150, 30-200)
- [x] 7.7 Save readings and update session status on completion

## 8. UI - Dashboard Screen

- [x] 8.1 Create `lib/screens/bp_dashboard_screen.dart`
- [x] 8.2 Display average systolic and diastolic
- [x] 8.3 Create line chart with fl_chart (systolic/diastolic lines)
- [x] 8.4 Show morning vs evening comparison
- [x] 8.5 Display readings count (X of Y)
- [x] 8.6 Show medical interpretation with threshold (135/85)
- [x] 8.7 Add disclaimer text

## 9. Dashboard Integration

- [x] 9.1 Add "Control 7 días" button to `_buildBloodPressureCard()` in dashboard_screen.dart
- [x] 9.2 Navigate to BloodPressureProtocolScreen on tap
- [x] 9.3 Add link to results dashboard when protocol has enough data

## 10. Testing & Verification

- [x] 10.1 Run `flutter analyze` to verify no issues
- [ ] 10.2 Test protocol creation with time validation
- [ ] 10.3 Test session recording with timer flow
- [ ] 10.4 Test notification scheduling (if emulator supports)
- [ ] 10.5 Test results dashboard with sample data
- [ ] 10.6 Test Light/Dark theme consistency
