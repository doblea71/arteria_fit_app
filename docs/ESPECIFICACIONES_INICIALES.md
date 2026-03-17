# ESPECIFICACIONES INICIALES

Necesitamos crear una app en Flutter que sirva para iniciar y llevar el control de los ejercicios de respiración y ejercicios isométricos indicándolo con un reloj en la pantalla e indicando la respiración que se hace ademas de llevar el control del tiempo de hacer el ejercicio isométrico.

## Arquitectura de la Aplicación

Para gestionar los tiempos de respiración (por ejemplo, el método 4-7-8) y los isométricos (mantener una posición), necesitarás una lógica de Streams o el uso de un Timer.

    Temporizador principal: Puedes usar la clase Timer.periodic de la librería dart:async.

    Interfaz de Usuario (UI): Un CustomPainter para crear un reloj circular que se llene o vacíe visualmente, o simplemente un widget de texto que cambie dinámicamente.

## Estructura de Datos sugerida

Podrías definir un modelo de datos para las rutinas:

´´´dart
class Ejercicio {
  final String nombre;
  final int duracionSegundos; // Tiempo total
  final String tipo; // "Respiración" o "Isométrico"
  final String instrucciones;

  Ejercicio({required this.nombre, required this.duracionSegundos, required this.tipo, this.instrucciones = ""});
}

´´´

## Lógica del Reloj en Flutter

Para el control en pantalla, un StatefulWidget sería la base:

´´´dart
import 'dart:async';

// ... dentro del State del widget
int _seconds = 30; // Tiempo inicial del ejercicio
Timer?_timer;

void startTimer() {
  _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    setState(() {
      if (_seconds > 0) {
        _seconds--;
      } else {
        _timer?.cancel();
        // Lógica para pasar al siguiente ejercicio
      }
    });
  });
}
´´´

## Sección de Nutrición

Para los alimentos recomendados para la tensión, podrías implementar una vista de lista (ListView) con tarjetas (Card) que detallen los beneficios de cada uno, basándonos en lo que mencione el video.

## Guía para tu App en Flutter

Para el reloj digital con animación circular, usaremos el paquete percent_indicator o un CustomPainter. Aquí tienes una implementación simplificada para que la integres:
Dependencias Sugeridas

En tu pubspec.yaml:

´´´yaml
dependencies:
  circular_countdown_timer: ^0.2.3 # Muy útil para lo que buscas
´´´

## Código del Widget del Temporizador

Este widget combina el reloj digital central con la animación circular:

´´´dart
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class TimerEjercicio extends StatefulWidget {
  @override
  _TimerEjercicioState createState() =>_TimerEjercicioState();
}

class _TimerEjercicioState extends State\<TimerEjercicio> {
  final CountDownController_controller = CountDownController();
  int _duracion = 30; // Tiempo por defecto para isométricos/respiración

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularCountDownTimer(
          duration: _duracion,
          initialDuration: 0,
          controller:_controller,
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          ringColor: Colors.grey[300]!,
          fillColor: Colors.blueAccent!, // Color para respiración/isométrico
          backgroundColor: Colors.white,
          strokeWidth: 20.0,
          strokeCap: StrokeCap.round,
          textStyle: TextStyle(
              fontSize: 33.0, color: Colors.black, fontWeight: FontWeight.bold),
          textFormat: CountdownTextFormat.S, // Reloj digital de segundos
          isReverse: true,
          onComplete: () {
            debugPrint('¡Ejercicio completado!');
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => _controller.start(), child: Text("Iniciar")),
            SizedBox(width: 10),
            ElevatedButton(onPressed: () =>\_controller.pause(), child: Text("Pausar")),
          ],
        )
      ],
    );
  }
}
´´´

## Lógica de Tiempos Recomendada

Basado en fisiología para hipertensión (el tema del video):

    Respiración: Ciclos de 4 segundos de inhalación / 6 segundos de exhalación (esto ayuda a activar el sistema parasimpático).

    Isométricos: Mantener una contracción suave (como apretar una pelota de goma) por 2 minutos al 30% de tu fuerza total, seguido de descanso.

## Estructura de la Pantalla de Alimentos

Puedes crear una sección de "Ingeniería de Fontanería" (como dice el video) usando un GridView.count:

    Regla 1: "Acompañante" (Potasio).

    Regla 2: "Snack Antitensión" (Magnesio).

    Regla 3: "Cena Dilatadora" (Nitratos).
