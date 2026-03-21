# SPEC-014 — Control de Tensión Arterial: Protocolo de 7 Días

## Status: Proposed

## Context

Antes de una consulta médica de control, el paciente debe realizar un
seguimiento de tensión arterial domiciliaria durante 7 días consecutivos,
con 3 tomas en la mañana y 3 tomas en la noche, separadas cada toma por
1 minuto y ambas sesiones por un mínimo de 6 a 9 horas entre sí.
La app ya cuenta con un widget `_buildBloodPressureCard()` en
`dashboard_screen.dart` que registra tensiones de forma puntual.
Esta nueva funcionalidad es un protocolo estructurado y temporal,
diferente al registro puntual existente, por lo que debe coexistir
con él sin reemplazarlo ni opacar su protagonismo.
Se requiere: planificación automática de 7 días, registro guiado de
tomas, notificaciones programadas en segundo plano, y un dashboard
de promedios con interpretación de resultados.

## Requirements

---

### BLOQUE A — Punto de Acceso e Integración

#### REQ-014-A1 — Punto de acceso sin reemplazar el widget existente

El acceso al protocolo de 7 días DEBE integrarse mediante un botón
secundario de texto o ícono pequeño dentro del widget existente
`_buildBloodPressureCard()` con la etiqueta "Control 7 días",
de forma que el registro puntual existente siga siendo el elemento
visual principal del card.
Alternativamente, si el card resulta sobrecargado, el botón puede
ubicarse inmediatamente debajo del card como elemento independiente.
La decisión final entre ambas opciones queda a criterio del
desarrollador según el espacio disponible en el layout.

#### REQ-014-A2 — Pantalla principal del protocolo

Al pulsar "Control 7 días", el sistema DEBE navegar a una nueva
pantalla `BloodPressureProtocolScreen` que muestre:

- El estado actual del protocolo (No iniciado / En curso / Completado).
- El botón para iniciar un nuevo protocolo si no hay uno activo.
- El calendario de 7 días con el progreso de tomas si hay uno activo.
- El botón de acceso al dashboard de resultados si hay datos suficientes.

---

### BLOQUE B — Planificación Automática

#### REQ-014-B1 — Inicio del protocolo con selección de hora

Al iniciar un nuevo protocolo, el sistema DEBE solicitar al usuario:

- Hora de la sesión matutina (ej: 07:30).
- Hora de la sesión nocturna (ej: 20:00).

El sistema DEBE validar que la diferencia entre ambas horas sea
de mínimo 6 horas y máximo 9 horas. Si no se cumple, DEBE mostrar
un mensaje de error y no permitir continuar.

#### REQ-014-B2 — Generación automática del calendario de 7 días

A partir de la fecha de inicio y las horas seleccionadas, el sistema
DEBE generar automáticamente un calendario de 14 sesiones
(7 mañanas + 7 noches) con sus fechas y horas reales, sin que el
usuario deba configurar cada día manualmente.

#### REQ-014-B3 — Persistencia del protocolo activo en SQLite

El protocolo activo DEBE persistirse en SQLite con la siguiente
información mínima: fecha de inicio, hora matutina, hora nocturna,
estado (activo/completado/cancelado) y el conjunto de tomas
registradas. Solo puede existir un protocolo activo a la vez.

#### REQ-014-B4 — Un único protocolo activo simultáneo

Si el usuario intenta iniciar un nuevo protocolo con uno ya activo,
el sistema DEBE advertirlo y requerir confirmación explícita para
cancelar el activo antes de iniciar uno nuevo.

---

### BLOQUE C — Registro Guiado de Tomas

#### REQ-014-C1 — Pantalla de sesión de tomas

Al iniciar una sesión (mañana o noche), el sistema DEBE mostrar
una pantalla `BloodPressureSessionScreen` con:

- El listado de recomendaciones previas a la medición
  (ver REQ-014-C2) con un checkbox o botón de confirmación.
- Tres bloques de entrada para las 3 tomas: sistólica (máxima)
  y diastólica (mínima) por toma.
- Un temporizador de 1 minuto entre tomas (activado por el usuario
  al completar cada toma) que indica cuándo puede realizarse
  la siguiente.
- Un campo de pulso (pulsaciones por minuto) opcional por toma.

#### REQ-014-C2 — Pantalla de recomendaciones previa a la sesión

Antes de permitir el ingreso de tomas, el sistema DEBE mostrar
las siguientes recomendaciones al usuario en formato de lista
verificable. El usuario DEBE confirmar haberlas leído antes de
continuar:

- Estar en una habitación tranquila y sin ruido.
- 30 minutos antes: evitar café, tabaco, alcohol, comida y ejercicio.
- Orinar antes de tomarse la tensión.
- Apoyar la espalda en una silla, sin cruzar las piernas.
- Permanecer 5 minutos en reposo y en silencio.
- Desnudar el brazo de referencia y colocar el manguito con el
  sensor en posición branquial.
- Apoyar el brazo sobre una superficie estable al nivel del
  corazón, con la palma hacia arriba.
  - Durante la medición: no mover el brazo ni hablar.

#### REQ-014-C3 — Temporizador de 1 minuto entre tomas

Después de registrar cada toma (excepto la tercera), el sistema
DEBE mostrar un temporizador regresivo de 60 segundos antes de
habilitar el ingreso de la siguiente toma. El usuario NO DEBE
poder ingresar la siguiente toma antes de que el temporizador
llegue a cero.

#### REQ-014-C4 — Temporizador de reposo de 5 minutos

Al inicio de la sesión, antes de la primera toma, el sistema
DEBE ofrecer un temporizador opcional de 5 minutos de reposo.
Si el usuario lo activa, el ingreso de la primera toma se
habilitará al completarse el conteo. Si no lo activa, puede
proceder directamente.

#### REQ-014-C5 — Validación de valores ingresados

El sistema DEBE validar los valores ingresados con los siguientes
rangos fisiológicos de referencia para alertar al usuario (no bloquear):

- Sistólica: entre 70 y 250 mmHg.
- Diastólica: entre 40 y 150 mmHg.
- Pulso (si se ingresa): entre 30 y 200 lpm.

Si se ingresa un valor fuera de rango, el sistema DEBE mostrar
una advertencia pero permitir guardar el dato igualmente, ya que
el usuario podría tener condiciones clínicas particulares.

#### REQ-014-C6 — Vista del calendario de progreso

La pantalla principal del protocolo DEBE mostrar los 7 días como
ítems de lista o cards, indicando para cada día:

- Fecha real del día.
- Estado de la sesión matutina (Pendiente / Completada / En curso).
- Estado de la sesión nocturna (Pendiente / Completada / En curso).
- Indicador visual de día actual.

---

### BLOQUE D — Sistema de Notificaciones Programadas

#### REQ-014-D1 — Notificación de aviso 10 minutos antes de cada sesión

El sistema DEBE programar una notificación local para cada una de
las 14 sesiones del protocolo, disparándose 10 minutos antes de
la hora configurada, con un mensaje que indique el tipo de sesión
(mañana o noche), la hora de la toma y un recordatorio de las
condiciones previas.

#### REQ-014-D2 — Notificación de inicio de sesión en el momento exacto

El sistema DEBE programar una segunda notificación para el momento
exacto de cada sesión, indicando que es hora de iniciar las tomas.

#### REQ-014-D3 — Funcionamiento con la app en segundo plano o cerrada

Las notificaciones DEBEN dispararse aunque la app esté en segundo
plano o completamente cerrada. Esto requiere el uso de un paquete
que soporte notificaciones programadas con ejecución nativa.

#### REQ-014-D4 — Solicitud de permisos de notificación

En el momento de iniciar el protocolo (no en el onboarding de la app),
el sistema DEBE solicitar los permisos necesarios para notificaciones:

- Android 13+ (API 33+): permiso `POST_NOTIFICATIONS`.
- iOS: permiso `UNUserNotificationCenter` con opciones
    `alert`, `sound` y `badge`.
Si el usuario deniega los permisos, el sistema DEBE informarle
que no recibirá recordatorios pero podrá seguir usando el protocolo
de forma manual.

#### REQ-014-D5 — Cancelación de notificaciones al cancelar el protocolo

Si el usuario cancela un protocolo activo, el sistema DEBE cancelar
todas las notificaciones programadas pendientes asociadas a ese
protocolo.

#### REQ-014-D6 — Cancelación de notificaciones al completar el protocolo

Al completar el día 7, el sistema DEBE cancelar automáticamente
cualquier notificación pendiente sobrante.

---

### BLOQUE E — Cálculo de Promedios y Dashboard de Resultados

#### REQ-014-E1 — Descarte del día 1 en el cálculo

El sistema DEBE excluir todas las tomas del día 1 del cálculo
de promedios finales, de acuerdo con el protocolo estándar de
monitoreo domiciliario.

#### REQ-014-E2 — Cálculo del promedio sistólico y diastólico (días 2-7)

El sistema DEBE calcular:

- Promedio de presión sistólica: suma de todas las tomas
  sistólicas de los días 2 al 7 dividida entre el número
  total de tomas válidas registradas.
- Promedio de presión diastólica: ídem para diastólica.

Solo se incluyen en el cálculo las tomas efectivamente registradas;
las sesiones no completadas no penalizan el promedio.

#### REQ-014-E3 — Disponibilidad del dashboard durante el protocolo

El dashboard de resultados DEBE estar disponible a partir del
tercer día (cuando existen datos de los días 2+ para promediar),
mostrando resultados parciales claramente etiquetados como
"Resultados parciales — Día X de 7".

#### REQ-014-E4 — Dashboard de resultados

La pantalla `BloodPressureDashboardScreen` DEBE mostrar:

- Promedio sistólico y diastólico (días 2-7 o parcial).
- Gráfico de línea con la evolución de las tomas a lo largo
  de los días (una línea para sistólica, una para diastólica).
- Promedio por sesión: mañana vs. noche (comparativa).
- Número total de tomas registradas vs. tomas esperadas.
- Interpretación de resultado (ver REQ-014-E5).

#### REQ-014-E5 — Interpretación del promedio con aviso médico

El sistema DEBE mostrar una interpretación del promedio final
basada en el umbral de referencia domiciliario de 135/85 mmHg:

- Por debajo de 135/85: "Sus promedios se encuentran dentro
  del rango de referencia domiciliario."
- Igual o superior a 135/85: "Sus promedios superan el umbral
  de referencia domiciliario (135/85 mmHg). Se recomienda
  consultar con su médico."
El sistema DEBE acompañar esta interpretación con un aviso
explícito: "Este resultado es orientativo y no constituye
un diagnóstico médico."

#### REQ-014-E6 — Exportación del registro completo

El sistema DEBERÍA permitir al usuario exportar el registro
completo de las 7 días como un resumen en texto plano (`.txt`)
o PDF simple, para llevar impreso o enviado al médico.
Este requisito es de segunda prioridad.

---

## Acceptance Criteria

- DADO QUE el usuario accede al dashboard y pulsa "Control 7 días",
  CUANDO no hay protocolo activo,
  ENTONCES ve la pantalla de inicio del protocolo con campos
  para configurar hora matutina y nocturna.

- DADO QUE el usuario configura hora mañana 07:30 y hora noche 20:00,
  CUANDO confirma el inicio,
  ENTONCES el sistema genera 14 sesiones con fechas reales
  y programa 28 notificaciones (14 de aviso + 14 de inicio).

- DADO QUE el usuario configura hora mañana 07:30 y hora noche 12:00,
  CUANDO intenta confirmar el inicio,
  ENTONCES el sistema muestra un error indicando que la diferencia
  mínima entre sesiones es de 6 horas.

- DADO QUE una sesión está programada para las 07:30,
  CUANDO son las 07:20,
  ENTONCES el dispositivo recibe una notificación de aviso aunque
  la app esté cerrada.

- DADO QUE el usuario abre una sesión de tomas,
  CUANDO completa la primera toma e intenta registrar la segunda,
  ENTONCES el sistema muestra el temporizador de 60 segundos y
  bloquea el ingreso hasta que se complete.

- DADO QUE se han completado los días 2 al 7,
  CUANDO el usuario accede al dashboard de resultados,
  ENTONCES ve el promedio sistólico y diastólico calculado solo
  con los datos de los días 2 a 7.

- DADO QUE el promedio final es 140/90 mmHg,
  CUANDO el usuario visualiza la interpretación,
  ENTONCES ve el mensaje de superación del umbral de referencia
  junto al aviso de que no es un diagnóstico médico.

- DADO QUE la app está en modo Dark,
  CUANDO el usuario navega por todas las pantallas del protocolo,
  ENTONCES todos los elementos respetan el ThemeProvider.

---

## Technical Notes

### Paquete recomendado para notificaciones

```yaml
dependencies:
  flutter_local_notifications: ^17.x.x
  timezone: ^0.9.x   # requerido para notificaciones con zona horaria
```

### Configuración Android requerida (AndroidManifest.xml)

```xml
<!-- Notificaciones exactas (Android 12+) -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>

<!-- Arranque al reiniciar el dispositivo (mantener notificaciones) -->
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"/>
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
  <intent-filter>
    <action android:name="android.intent.action.BOOT_COMPLETED"/>
    <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
  </intent-filter>
</receiver>
```

> CRÍTICO: Sin `RECEIVE_BOOT_COMPLETED` las notificaciones
> programadas se pierden si el dispositivo se reinicia.

### Inicialización del servicio de notificaciones

```dart
// services/notification_service.dart

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false, // se pide al iniciar protocolo
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
  }

  static Future<void> scheduleSession({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'bp_protocol_channel',
          'Control de Tensión',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
```

### Esquema SQLite sugerido

```sql
-- Protocolo activo
CREATE TABLE bp_protocol (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  start_date    TEXT NOT NULL,       -- ISO 8601
  morning_time  TEXT NOT NULL,       -- "HH:mm"
  evening_time  TEXT NOT NULL,       -- "HH:mm"
  status        TEXT NOT NULL        -- active | completed | cancelled
);

-- Sesiones generadas automáticamente
CREATE TABLE bp_session (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  protocol_id   INTEGER NOT NULL,
  day_number    INTEGER NOT NULL,    -- 1 a 7
  session_type  TEXT NOT NULL,       -- morning | evening
  scheduled_at  TEXT NOT NULL,       -- ISO 8601 datetime
  status        TEXT NOT NULL,       -- pending | completed | skipped
  FOREIGN KEY (protocol_id) REFERENCES bp_protocol(id)
);

-- Tomas individuales (3 por sesión)
CREATE TABLE bp_reading (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id    INTEGER NOT NULL,
  reading_index INTEGER NOT NULL,    -- 1, 2 o 3
  systolic      INTEGER NOT NULL,    -- mmHg
  diastolic     INTEGER NOT NULL,    -- mmHg
  pulse         INTEGER,             -- lpm, opcional
  recorded_at   TEXT NOT NULL,       -- ISO 8601 datetime
  FOREIGN KEY (session_id) REFERENCES bp_session(id)
);
```

### Lógica de cálculo de promedios

```dart
// Excluir día 1 (day_number == 1)
final validReadings = readings
    .where((r) => r.dayNumber > 1)
    .toList();

final avgSystolic = validReadings
    .map((r) => r.systolic)
    .reduce((a, b) => a + b) / validReadings.length;

final avgDiastolic = validReadings
    .map((r) => r.diastolic)
    .reduce((a, b) => a + b) / validReadings.length;

// Umbral de referencia domiciliario
final isAboveThreshold =
    avgSystolic >= 135 || avgDiastolic >= 85;
```

### Estructura de archivos nuevos

```text
lib/
  models/
    bp_protocol_model.dart
    bp_session_model.dart
    bp_reading_model.dart
  services/
    notification_service.dart       ← nuevo o extender existente
    bp_protocol_service.dart        ← lógica de negocio del protocolo
  screens/
    bp_protocol_screen.dart         ← pantalla principal / calendario
    bp_session_screen.dart          ← registro guiado de tomas
    bp_recommendations_screen.dart  ← checklist de recomendaciones
    bp_dashboard_screen.dart        ← gráficos y promedios
  widgets/
    bp_day_card.dart                ← card de día en el calendario
    bp_reading_input.dart           ← bloque de entrada de una toma
```

### Archivos modificados

- `lib/screens/dashboard_screen.dart`
  (agregar acceso "Control 7 días" en `_buildBloodPressureCard()`)
- `lib/services/database_service.dart`
  (agregar métodos para las nuevas tablas, si se usa el servicio
  centralizado de SPEC-004)
- `pubspec.yaml`
  (agregar `flutter_local_notifications` y `timezone`)
- `android/app/src/main/AndroidManifest.xml`
  (permisos de notificaciones exactas y boot receiver)

## Dependencias

| SPEC | Tipo de dependencia |
|---|---|
| SPEC-004 (SQLite) | Preferido tenerlo implementado; si no, crear DatabaseService en este SPEC |
| SPEC-002 (Tema) | Los widgets nuevos deben respetar ThemeProvider |
| SPEC-013 (Splash/Icon) | Sin dependencia funcional |

## Notas de implementación críticas

1. **Notificaciones exactas en Android 12+**: Google restringe
   `SCHEDULE_EXACT_ALARM`. En Android 13+, la app puede ser
   enviada a configuración del sistema si el usuario denegó
   previamente el permiso. Manejar este caso con un mensaje
   informativo.

2. **Reinicio del dispositivo**: Las notificaciones de
   `flutter_local_notifications` NO sobreviven a un reinicio del
   dispositivo a menos que el `BootReceiver` esté correctamente
   configurado en el manifest Y se reprogramen en el arranque.
   El `BootReceiver` incluido en el paquete maneja esto
   automáticamente si el manifest está correcto.

3. **Un solo protocolo activo**: Antes de insertar un nuevo
   protocolo, verificar en la base de datos que no exista uno
   con `status = 'active'`. Si existe, mostrar diálogo de
   confirmación antes de cancelarlo.

4. **Zona horaria**: Usar siempre `tz.TZDateTime` para programar
   notificaciones, nunca `DateTime` nativo, para evitar
   desplazamientos de hora por cambios de horario estacional.
