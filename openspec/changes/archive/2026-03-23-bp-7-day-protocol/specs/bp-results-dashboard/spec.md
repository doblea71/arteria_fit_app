# bp-results-dashboard

## ADDED Requirements

### Requirement: Day 1 exclusion from averages

The system SHALL exclude all readings from day 1 when calculating final averages, per clinical protocol standards.

#### Scenario: Day 1 readings excluded

- **WHEN** calculating averages from protocol with 14 sessions completed
- **THEN** system uses only readings from days 2-7 (12 sessions)

### Requirement: Systolic and diastolic average calculation

The system SHALL calculate the average systolic and diastolic pressure from valid readings (days 2-7).

#### Scenario: Average calculation

- **WHEN** user views results dashboard
- **THEN** system displays average systolic and average diastolic calculated from days 2-7

### Requirement: Dashboard available from day 3

The results dashboard SHALL be accessible from day 3 (when day 2 data exists for averaging), displaying partial results clearly labeled.

#### Scenario: Partial results on day 3

- **WHEN** user completes day 2 sessions
- **AND** accesses dashboard
- **THEN** system shows "Resultados parciales — Día 3 de 7"

### Requirement: Line chart visualization

The dashboard SHALL display a line chart showing systolic and diastolic trends over the 7 days (or partial period).

#### Scenario: Chart shows trends

- **WHEN** user views dashboard with completed sessions
- **THEN** line chart displays systolic and diastolic values over time

### Requirement: Morning vs evening comparison

The dashboard SHALL show average comparison between morning and evening sessions.

#### Scenario: Session comparison displayed

- **WHEN** user views dashboard
- **THEN** system shows average morning BP vs average evening BP

### Requirement: Readings count display

The dashboard SHALL show total readings registered vs expected (e.g., "24 de 36 lecturas").

#### Scenario: Readings count shown

- **WHEN** user views dashboard
- **THEN** system displays "X de Y lecturas" with progress indicator

### Requirement: Medical reference interpretation

The system SHALL interpret results against home reference threshold (135/85 mmHg):
- Below threshold: "Sus promedios se encuentran dentro del rango de referencia domiciliario."
- At or above threshold: "Sus promedios superan el umbral de referencia domiciliario (135/85 mmHg). Se recomienda consultar con su médico."

The system SHALL accompany interpretation with disclaimer: "Este resultado es orientativo y no constituye un diagnóstico médico."

#### Scenario: Below threshold interpretation

- **WHEN** average systolic < 135 AND average diastolic < 85
- **THEN** system displays green success message with reference range text

#### Scenario: Above threshold interpretation

- **WHEN** average systolic >= 135 OR average diastolic >= 85
- **THEN** system displays warning message with threshold info and medical consultation recommendation
- **AND** disclaimer text is shown
