## Context

The app currently has a single-point blood pressure recording widget in the dashboard. Patients preparing for medical consultations need a structured 7-day monitoring protocol following clinical guidelines (ESH/ESH): 3 readings in the morning and 3 at night, with 1-minute intervals between readings, and at least 6 hours between sessions.

**Current State:**
- Single BP recording widget in dashboard (`_buildBloodPressureCard`)
- SQLite database exists (SPEC-004) for persistence
- Theme provider already implemented for Dark/Light mode

**Constraints:**
- Only one active protocol at a time
- Day 1 readings excluded from average calculation (clinical standard)
- Notifications must work with app in background/closed
- Android 12+ requires exact alarm permissions

## Goals / Non-Goals

**Goals:**
- Seamless integration with existing BP card (not replacing it)
- Full protocol lifecycle: start → track → complete → view results
- Background notifications for all 14 sessions
- Accurate average calculation excluding day 1
- Results dashboard with visualization and medical reference interpretation

**Non-Goals:**
- PDF export (second priority, not in initial scope)
- Cloud sync or data sharing
- Integration with external blood pressure devices
- Real-time monitoring or alerts

## Decisions

### 1. SQLite Schema Extensions

**Decision:** Add three new tables to existing database (`bp_protocol`, `bp_session`, `bp_reading`)

**Rationale:** Reuses existing DatabaseService from SPEC-004, maintains data locality, supports complex queries for averages and progress tracking.

**Alternative:** Use SharedPreferences - insufficient for structured data with relationships.

### 2. Notification Service Architecture

**Decision:** Create dedicated `NotificationService` singleton using `flutter_local_notifications`

**Rationale:** Isolates notification logic, supports Android boot persistence via receiver, handles timezone-aware scheduling with `timezone` package.

**Alternative:** Use Provider-based notification manager - mixes concerns, harder to test.

### 3. Session Flow Architecture

**Decision:** Separate screens for recommendations checklist and actual recording

**Rationale:** Ensures user acknowledges pre-measurement conditions before recording, follows clinical protocol, improves data quality.

**Alternative:** Inline checklist - clutters UI, user might skip accidentally.

### 4. Timer Implementation

**Decision:** Use `Timer.periodic` with countdown state in StatefulWidget

**Rationale:** Simple, reliable, no external dependencies. Countdown visible to user prevents premature entry.

**Alternative:** External timer package - unnecessary dependency for simple countdown.

### 5. Dashboard Chart Library

**Decision:** Use `fl_chart` package for line chart visualization

**Rationale:** Mature Flutter chart library, supports multiple series (systolic/diastolic), customizable styling.

**Alternative:** Custom Canvas drawing - more work, less maintainable.

## Risks / Trade-offs

- **[Risk]** Exact alarm permission denied on Android 12+ → **Mitigation:** Show informative message, allow manual use without notifications
- **[Risk]** Device reboot clears scheduled notifications → **Mitigation:** Boot receiver reprogramming via `ScheduledNotificationBootReceiver`
- **[Risk]** User bypasses 1-minute timer → **Mitigation:** Timer state in widget prevents next reading input until countdown completes
- **[Risk]** Incomplete sessions affect data quality → **Mitigation:** Dashboard shows "X of Y readings" count, partial data still displayed with label

## Open Questions

1. Should the protocol auto-complete after day 7, or require user confirmation?
2. Should we support editing/deleting individual readings after recording?
3. What happens if user records readings for day 1 only and abandons protocol?
