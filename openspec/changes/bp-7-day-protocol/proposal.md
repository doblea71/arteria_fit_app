## Why

Patients need a structured 7-day blood pressure monitoring protocol before medical consultations, with 3 morning and 3 evening readings per day. Currently, the app only supports single-point BP recordings. A guided protocol with scheduled notifications, progress tracking, and results dashboard will help users follow clinical standards and provide meaningful data to their physicians.

## What Changes

- Add "Control 7 días" access point in the existing blood pressure card on dashboard
- Create `BloodPressureProtocolScreen` with protocol status, calendar view, and navigation to sessions
- Implement guided session flow with pre-measurement recommendations, 3 readings per session, and 60-second inter-reading timer
- Add scheduled local notifications (10 min before + at session time) for all 14 sessions
- Persist protocol, sessions, and readings in SQLite
- Calculate and display averages (excluding day 1) with medical reference interpretation
- Add results dashboard with line chart, morning vs evening comparison

## Capabilities

### New Capabilities

- `bp-protocol-access`: Entry point integration in dashboard blood pressure card
- `bp-protocol-management`: Protocol lifecycle (create, cancel, complete) with 7-day auto-planning
- `bp-session-recording`: Guided 3-reading session with recommendations, timers, and validation
- `bp-notification-scheduler`: Local notifications with background support and boot persistence
- `bp-results-dashboard`: Averages calculation (days 2-7), line chart visualization, and medical interpretation

### Modified Capabilities

<!-- No existing capability requirements are being modified -->

## Impact

- **New dependencies**: `flutter_local_notifications`, `timezone`
- **New models**: `bp_protocol_model.dart`, `bp_session_model.dart`, `bp_reading_model.dart`
- **New services**: `notification_service.dart`, `bp_protocol_service.dart`
- **New screens**: `bp_protocol_screen.dart`, `bp_session_screen.dart`, `bp_recommendations_screen.dart`, `bp_dashboard_screen.dart`
- **New widgets**: `bp_day_card.dart`, `bp_reading_input.dart`
- **Modified files**: `dashboard_screen.dart` (access button), `database_service.dart` (new tables), `pubspec.yaml`, `AndroidManifest.xml`
- **Database**: New tables for protocol, session, and readings
