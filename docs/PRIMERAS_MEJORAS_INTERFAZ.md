# MEJORAS DE INTERFAZ Y FUNCIONALIDADES

## Feature breathing_screen.dart

* Cuando el tiempo del ejercicio de respiración llega a 0 viniendo desde los 5 minutos el paso final del método 4-7-8, en el paso 8 se queda "corto", vale decir, cuando se hace el primero paso que es la inspiración en el temporizador se muestra que restan 11 segundos para terminar, cuando se hace el segundo paso que es la retención de la respiración en el temporizador se muestra que falta los ultimos 7 segundos que le quedan al temporizador faltando así los ultimos 8 segundos que representan a la parte final del ejercicio que es la exhalación con lo que al cerrarse el ejercicio porque ya el tiempo ha terminado no se sabe cuando finalizar de exhalar. Lo que ayudaría sería mantener por esos ultimos segundos el indicador "Exhalar" por unos segundos y luego si, finalizar el ejercicio con la logica actual que es volver a activar los botones y cesar la animación.

## Fecature Temporizador

* Cuando ya teniendo la aplicación instalada en un dispositivo real y el usuario tiene el modo oscuro activado del sistema operativo ¿como hacer que el tema del sisitema operativo no impacte el modo Ligth/Dark propio de la app? En los actuales momentos, algunas pantallas toman en cuenta el tema que tiene el sistema operativo (como por ejemplo el dashboard) y otras pantallas no (como por ejemplo la isometrics_screen.dart) con lo que los colores contrastan demasiado, incluso algunas pantallas se ven con fondo oscuro y otras pantallas se ven con fondo claro y aun no se ha usado el toggle del tema de la app. Tambien hay que mencionar que pareciera que el modo Light/Dark se pierde en diferentes pantallas de la aplicación y muchas veces hay que presionar el botón del toggle de tema Light/Dark varias veces para que se tome en cuenta el "custom theme" de la app.

## Feature Notificacio en forma de Vibración

* Tanto en el ejercicio de respiración como en el ejercicio isométrico se habia prometido que en cada cambio de paso del ejercicio se iba a implementar un aviso al usuario en forma de vibración para que el usuario no tenga que quedarse mirando la pantalla del dispositivo.

## Mejora de Seguimiento de Objetivos

* En el dashboard_screen.dart tenemos el widget buildPgrogressCard() con datos duros que pudieramos mejorar implementando el guardado de datos en SQLite llevando el control de la cantidad de veces que se han completado los ejercicios y ésto lo podemos agregar dentro de la nueva pantalla a la que podemos acceder desde el BottomNavigationBarItem() llamado "Ajustes", creando testfields para registrar el numero maximo diario de cada ejercicio, por ejemplo: para el ejercicio de respiración 5 veces al dia y para el ejercicio isométrico 4 veces al dia.

## Mejora de la Pantalla de Nutrición

* En la pantalla de nutrición, en el widget buildFoodCard() el color de fondo del card es blanco y el color del texto es negro, lo que hace que el contraste sea muy bajo y dificulte la lectura del texto. Sería ideal que el color de fondo del card fuera negro y el color del texto blanco para que el contraste sea mayor y la lectura sea más fácil pero tomando en cuenta que tambien tenemos los temas Light/Dark de la app.
* Al final de la pantalla de nutrición hay un Card que habla de las Semillas de Sandia y no es lo correcto. Las semillas de las que se debe habla en ese Card son de las semillas de Calabaza así q ue, el icono también debería ser alegórico bien sea a la calabaza o a sus semillas.

## Mejora de la Pantalla de Isométricos

* En la pantalla de isométricos, en el widget buildIsometricCard() el color de fondo del card es blanco y el color del texto es negro, lo que hace que el contraste sea muy bajo y dificulte la lectura del texto. Sería ideal que el color de fondo del card fuera negro y el color del texto blanco para que el contraste sea mayor y la lectura sea más fácil pero tomando en cuenta que tambien tenemos los temas Light/Dark de la app.

## Mejora de la Pantalla de Respiración

* En la pantalla de respiración, en el widget buildBreathingCard() el color de fondo del card es blanco y el color del texto es negro, lo que hace que el contraste sea muy bajo y dificulte la lectura del texto. Sería ideal que el color de fondo del card fuera negro y el color del texto blanco para que el contraste sea mayor y la lectura sea más fácil pero tomando en cuenta que tambien tenemos los temas Light/Dark de la app.

## Mejora del Dashboard

* En el dashboard_screen.dart tenemos el widget buildProgressCard() con datos duros que pudieramos mejorar implementando el guardado de datos en SQLite llevando el control de la cantidad de veces que se han completado los ejercicios y ésto lo podemos agregar dentro de la nueva pantalla a la que podemos acceder desde el BottomNavigationBarItem() llamado "Ajustes", creando testfields para registrar el numero maximo diario de cada ejercicio, por ejemplo: para el ejercicio de respiración 5 veces al dia y para el ejercicio isométrico 4 veces al dia.

## Mejora del BottomNavigationBar

* En el dashboard_screen.dart tenemos el BottomNavigationBar con 4 items, pero en el item "Actividad" no se muestra nada, sería ideal que se muestre algo, por ejemplo: una lista de los ejercicios que se han completado, con la fecha y la hora en la que se han completado.
