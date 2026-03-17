# AGENTS.md - Proyecto Arteria Fit

Este archivo sirve como la fuente de verdad y memoria compartida para los agentes de IA que colaboren en este proyecto. **DEBE mantenerse actualizado después de cada cambio significativo.**

## 🎯 Visión del Proyecto

**Arteria Fit** es una aplicación de bienestar enfocada en la salud cardiovascular, específicamente diseñada para ayudar a los usuarios a gestionar su tensión arterial a través de ejercicios guiados de respiración, ejercicios isométricos y educación nutricional.

## 🛠 Tech Stack

- **Framework:** Flutter (Android/iOS/Web)
- **Estado:** Inicial (Estructura base creada)
- **Diseño:** Enfocado en visuales premium, animaciones fluidas y accesibilidad.

## 🎨 Principios de Diseño (Vía Stitch MCP)

- **Stitch Project ID:** `14762469515617644542`
- **Atmósfera:** Calma, profesional, médica pero moderna (estilo Apple Health).
- **Componentes:**
  - Micro-animaciones para guiar la respiración.
  - Temporizadores circulares elegantes.
  - Tarjetas nutricionales con enfoque visual "Premium".

## 📋 Road Map & Tareas Actuales

1. [x] Definir Sistema de Diseño en Stitch (Colores, Tipografía).
2. [x] Implementar estructura base en Flutter (Router, Temas, Riverpod).
3. [x] Generar pantalla de inicio/dashboard con indicadores rápidos.
4. [x] Implementar la pantalla de Respiración Guiada con animaciones fluidas.
5. [x] Implementar la pantalla de Ejercicios Isométricos con cronómetro circular.
6. [x] Crear la base de datos/sección de Nutrición.
7. [x] Implementar modo Dark/Light con toggle en AppBar.

## 🧠 Instrucciones para Agentes

- Antes de comenzar, lee `docs/ESPECIFICACIONES_INICIALES.md`.
- Prioriza la estética y la experiencia de usuario (UX).
- Utiliza el MCP de Stitch para prototipar interfaces antes de la implementación en Flutter.
- Mantén este archivo actualizado con las últimas decisiones de arquitectura o diseño.

## 📚 Context7 — Documentación Actualizada para LLMs

**Regla automática:** Siempre que necesites documentación de una librería o API (Flutter, Dart, Riverpod, Go Router, etc.), consultar código de ejemplo, o generar código que dependa de una versión específica de un paquete, **usa Context7 automáticamente sin que el usuario tenga que pedirlo**.

### ¿Cómo usarlo?

Context7 está instalado globalmente como CLI (`ctx7` v0.3.6+). Se puede invocar de dos formas:

**1. Desde el prompt del agente (forma natural):**

```text
¿Cómo configuro un GoRouter con guards en Flutter? use context7
```

**2. Especificando la librería directamente (más rápido y preciso):**

```text
use context7:/flutter/flutter
use context7:/rrousselgit/riverpod
```

**3. Via CLI para consultas directas:**

```bash
ctx7 library flutter "navigation guards"  # Busca librería por nombre
ctx7 docs /flutter/flutter "GoRouter redirect"  # Obtiene docs específicas
```

### Librerías clave del proyecto

| Librería       | Context7 ID                                     |
| -------------- | ----------------------------------------------- |
| Flutter / Dart | `/flutter/flutter`                              |
| Riverpod       | `/rrousselgit/riverpod`                         |
| Go Router      | `/flutter/packages`                             |
| Material 3     | `/material-components/material-components-web`  |

### Cuándo activarlo automáticamente

- Al escribir código que usa un paquete de `pub.dev`.
- Al resolver errores de API deprecada (como `withOpacity` → `withValues`).
- Al implementar nuevas pantallas o widgets complejos.
- Al configurar dependencias en `pubspec.yaml`.
- **Siempre que haya riesgo de usar una API desactualizada o inexistente.**

## 🎨 Sistema de Temas

### Light Mode

- Background: `0xFFF6F6F8`
- Surface: `0xFFF1F5F9`
- Card: `0xFFFFFFFF`
- Texto: `0xFF0F172A`
- Texto muted: `0xFF64748B`
- Border: `0xFFE2E8F0`

### Dark Mode

- Background: `0xFF0F1623`
- Surface: `0xFF1A2436`
- Card: `0xFF151C2B`
- Texto: `0xFFFFFFFF`
- Texto muted: `0xFF94A3B8`
- Border: `0xFF2F436A`

### Implementación

- Provider: `lib/core/providers/theme_provider.dart` (usa Riverpod NotifierProvider)
- Toggle: Botón en AppBar del Dashboard con ícono sol/luna
- Estados: `ThemeMode.system` por defecto, cambia a `light` o `dark`

## ⚠️ Notas Técnicas (Flutter 3.19+)

Para evitar advertencias de depreciación (deprecation warnings) y seguir los estándares de Material 3:

- **Colores:** NO usar `onBackground` ni `background`. Usar `onSurface` y `surface` respectivamente.
- **Opacidad:** Preferir el uso de `color.withValues(alpha: 0.1)` en lugar de `color.withOpacity(0.1)` para manejar la transparencia de forma más moderna.

---

*Última actualización: 2026-03-17 - Añadida integración de Context7 (documentación actualizada para LLMs) con regla de activación automática.*
