📄 DOCUMENTO DE ESPECIFICACIONES (SPECS)

1. Feature: Breathing Logic (Graceful Exit)

Problema: El cronómetro de 5 min corta el último ciclo 4-7-8, impidiendo la exhalación final de 8 segundos.

    SPEC: Modificar el motor del temporizador en breathing_screen.dart.

    Lógica: * Si currentTime == 0 y el estado actual es "Exhalando", no finalizar inmediatamente.

        Inyectar un ExtraBufferTime de 8 segundos (o el tiempo restante del ciclo actual).

        Mantener el label "Exhalar" y la animación activa hasta completar el ciclo.

    Criterio de Aceptación: El usuario debe poder terminar su última exhalación completa aunque el reloj global marque 0:00.

2. Feature: Theme Management (System Override)

Problema: Inconsistencia entre el tema del OS y el CustomTheme de la app.

    SPEC: * En el MaterialApp (main.dart), forzar themeMode: ThemeMode.light (o dark según el estado del toggle).

        Eliminar cualquier dependencia de MediaQuery.platformBrightnessOf(context).

        Asegurar que el ThemeData personalizado se pase por todo el árbol de widgets usando un ChangeNotifier o Provider para el ThemeManager.

    Criterio de Aceptación: Al cambiar el tema del teléfono, la app debe permanecer inalterada a menos que el usuario use el toggle interno.

3. Feature: Haptic Feedback (Vibration)

Problema: El usuario depende de mirar la pantalla para saber cuándo cambiar de fase.

    SPEC: * Importar package:vibration/vibration.dart o usar HapticFeedback nativo de Flutter.

        Evento: Ejecutar una vibración corta (Vibration.vibrate(duration: 500)) en cada cambio de fase:

            Inhalar -> Retener.

            Retener -> Exhalar.

            Exhalar -> Inhalar.

    Criterio de Aceptación: El dispositivo debe vibrar físicamente al cambiar el label de instrucción.

4. Feature: Persistence & Goals (SQLite)

Problema: Datos "hardcodeados" y falta de seguimiento.

    SPEC: * DB Schema: Crear tabla exercises_log (id, type, timestamp) y tabla user_goals (type, max_daily).

        Pantalla Ajustes: Implementar TextFields con TextEditingController que guarden en SharedPreferences o SQLite los límites diarios.

        Dashboard: El buildProgressCard debe ejecutar un SELECT COUNT filtrado por la fecha actual para comparar contra el objetivo guardado.

    Criterio de Aceptación: Al completar un ejercicio, el contador del Dashboard debe incrementarse automáticamente tras leer la DB.

5. UI: Card Contrast & Correction (Nutrition/Iso/Breath)

Problema: Bajo contraste y error en contenido (Semillas de Sandía).

    SPEC:

        Contraste: En los widgets buildFoodCard, buildIsometricCard y buildBreathingCard, el Color del Card y del Text debe ser reactivo al Theme.of(context).

            Light Mode: Card Blanco / Texto Negro.

            Dark Mode: Card Gris Oscuro / Texto Blanco (Evitar Negro puro sobre Blanco puro para reducir fatiga visual).

        Corrección de Contenido: Cambiar "Semillas de Sandía" por "Semillas de Calabaza".

        Icono: Usar FontAwesomeIcons.pumpkin o un asset SVG de una calabaza.

    Criterio de Aceptación: Lectura clara en ambos modos y datos nutricionales veraces según el video.

6. Feature: Activity Log (BottomNavBar)

Problema: Pantalla de "Actividad" vacía.

    SPEC:

        Transformar la pantalla de Actividad en un ListView.builder.

        Consultar la tabla exercises_log en orden descendente (ORDER BY timestamp DESC).

        Cada item mostrará: Icono del tipo, Nombre del ejercicio, Fecha y Hora.

    Criterio de Aceptación: El usuario debe ver un historial cronológico de sus sesiones completadas.