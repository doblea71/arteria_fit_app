## ADDED Requirements

### Requirement: Vibración al inicio de cada fase de contracción
El sistema DEBE disparar una vibración háptica corta al inicio de cada fase activa de contracción isométrica.

#### Scenario: Contracción isométrica inicia
- **WHEN** la fase de contracción isométrica comienza
- **THEN** el dispositivo vibra con patrón de contracción (doble pulso o fallback)

### Requirement: Vibración al inicio de cada fase de descanso
El sistema DEBE disparar una vibración háptica corta al inicio de cada período de descanso entre contracciones o entre series.

#### Scenario: Fase de descanso inicia
- **WHEN** la fase de descanso comienza
- **THEN** el dispositivo vibra con patrón de descanso (pulso único suave o fallback)

### Requirement: Vibración en transición del último paso al primero
Al completarse el último paso de un ciclo isométrico y comenzar el siguiente ciclo, el sistema DEBE disparar la vibración correspondiente sin omisiones ni duplicados.

#### Scenario: Nuevo ciclo inicia después del último paso
- **WHEN** el ciclo actual termina y comienza un nuevo ciclo desde el primer paso
- **THEN** el dispositivo vibra exactamente una vez al iniciar la primera fase del nuevo ciclo

### Requirement: Patrón diferenciado para contracción vs descanso
El sistema DEBERÍA usar patrones hápticos distintos para diferenciar al usuario entre fase de contracción y fase de descanso.

#### Scenario: Patrones diferenciados disponibles
- **WHEN** el dispositivo soporta patrones personalizados
- **THEN** contracción usa doble pulso (100ms, pausa, 100ms) y descanso usa pulso único (150ms)

#### Scenario: Patrones no disponibles
- **WHEN** el dispositivo no soporta patrones personalizados
- **THEN** ambos tipos de fase usan un único pulso corto (≤ 200ms)

### Requirement: Respeto a configuración de vibración del dispositivo
Si el dispositivo tiene vibración desactivada, el sistema NO DEBE lanzar excepciones ni interrumpir el ejercicio.

#### Scenario: Vibración desactivada no causa errores
- **WHEN** la vibración está desactivada a nivel de sistema
- **THEN** el ejercicio continúa normalmente sin errores ni vibración
