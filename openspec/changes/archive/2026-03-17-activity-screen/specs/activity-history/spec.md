## ADDED Requirements

### Requirement: Activity History Screen displays chronological exercise list
The Activity screen SHALL display a chronological list (most recent first) of all completed exercises with the following information per item: exercise type, completion date and time, and duration in minutes/seconds.

#### Scenario: Display exercises in chronological order
- **WHEN** user navigates to Activity screen with 3 completed exercises
- **THEN** user sees 3 items ordered from most recent to oldest

#### Scenario: Each exercise shows type, date/time, and duration
- **WHEN** user views an exercise item in the list
- **THEN** user sees exercise type icon, completion timestamp, and total duration

### Requirement: Visual differentiation between exercise types
Each list item SHALL visually differentiate (icon and/or color) between breathing exercise and isometric exercise.

#### Scenario: Breathing exercises show breathing icon
- **WHEN** user views a breathing exercise item
- **THEN** user sees a breathing/lungs icon with a calming color (e.g., blue/teal)

#### Scenario: Isometric exercises show strength icon
- **WHEN** user views an isometric exercise item
- **THEN** user sees a strength/fitness icon with a distinct color (e.g., orange/amber)

### Requirement: Empty state when no exercises exist
When no exercise records exist, the Activity screen SHALL display an informative empty state (message + icon) indicating that no exercises have been completed yet.

#### Scenario: Empty state displays when no exercises
- **WHEN** user navigates to Activity screen with no completed exercises
- **THEN** user sees a friendly message and icon, no error, no empty list

### Requirement: Theme consistency (Light/Dark)
The Activity screen SHALL respond to the app's ThemeProvider, maintaining visual consistency in both Light and Dark modes.

#### Scenario: Activity screen adapts to Light mode
- **WHEN** user has Light mode enabled
- **THEN** Activity screen displays with light backgrounds and dark text

#### Scenario: Activity screen adapts to Dark mode
- **WHEN** user has Dark mode enabled
- **THEN** Activity screen displays with dark backgrounds and light text
