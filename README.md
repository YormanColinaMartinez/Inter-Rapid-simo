# 📱 Inter Rapidísimo – Prueba Técnica iOS (SwiftUI)

Este repositorio contiene la solución a la prueba técnica iOS solicitada por **Inter Rapidísimo**, desarrollada utilizando **SwiftUI**, **async/await** y **SQLite3** como sistema de persistencia local.

El foco del desarrollo estuvo en construir una aplicación **estable**, **clara en su flujo**, y **fácil de evaluar**, priorizando la correcta gestión del estado, la robustez ante errores y el cumplimiento estricto de los requisitos funcionales.

---

## 🚀 Cómo correr el proyecto

### Requisitos
- Xcode 15 o superior  
- iOS 16 o superior  
- Dispositivo físico recomendado para pruebas de cámara

### Pasos
1. Clonar el repositorio.
2. Abrir el archivo `.xcodeproj` en Xcode.
3. Seleccionar un simulador o dispositivo.
4. Ejecutar el proyecto (`Run`).

> ⚠️ Para el módulo de fotos con cámara, se recomienda usar un **dispositivo físico**.  
> En simulador se habilita selección desde galería.

---

## 🧱 Arquitectura y decisiones técnicas

Se utilizó una arquitectura **MVVM ligera**, con separación clara de responsabilidades:

- **Views (SwiftUI)**: renderizan la UI en función del estado.
- **ViewModels (@MainActor)**: manejan la lógica de presentación.
- **Repositories**: encapsulan el acceso a red y base de datos.
- **SQLiteManager**: capa centralizada de persistencia local.
- **RootView**: punto único de decisión del flujo de navegación.

### Decisión clave
> Toda la navegación global se controla exclusivamente desde `RootView`.

Esta decisión evita estados duplicados, navegación imperativa y problemas de reconciliación comunes en SwiftUI cuando múltiples vistas intentan manejar el flujo.

---

## 🔄 Control de versión (Requisito 1.1)

- Consulta del endpoint remoto de versión.
- Obtención de versión local desde `CFBundleShortVersionString`.
- Comparación normalizada (numérica).

### Comportamiento
- **Versión local menor**: se muestra alerta de actualización y se permite continuar.
- **Versión igual**: se continúa normalmente.
- **Versión local mayor**: se alerta de ambiente inconsistente y se permite continuar.

### Supuesto técnico
El endpoint retorna un **valor plano (ej. `"100"`) y no un JSON**, por lo que se implementó un cliente de red específico para manejar este tipo de respuesta.

---

## 🔐 Autenticación (Requisito 1.2)

- Login vía `POST` usando headers y body provistos.
- Manejo de loading y error.
- Persistencia local del usuario autenticado.
- Restauración automática de sesión al relanzar la app.

El estado de autenticación se maneja mediante un `SessionViewModel` centralizado, observado por `RootView`.

---

## 🏠 Home y navegación

- Pantalla principal posterior al login.
- Visualización de información básica del usuario.
- Acceso a los módulos:
  - Tablas locales
  - Localidades
  - Fotos
- Logout:
  - Elimina el usuario persistido.
  - Actualiza el estado de sesión.
  - Retorna automáticamente a Login.

No se utiliza navegación imperativa (`NavigationLink(isActive:)`) para el flujo principal.

---

## 📍 Localidades

El servicio remoto para localidades responde con **401 / 404 (no autorizado)**.

### Decisión tomada
Para no bloquear el flujo de la aplicación:
- El error se maneja de forma controlada.
- Se implementa un **fallback local**.
- Las localidades se persisten y se muestran desde SQLite.

Este comportamiento está documentado y es consistente con escenarios reales de indisponibilidad de servicios.

---

## 📸 Fotos (Requisito 3.4)

### Funcionalidad
- Lista vertical con:
  - Miniatura a la izquierda.
  - Nombre y fecha a la derecha.
- Barra inferior fija con:
  - Botón de cámara (captura).
  - Botón de visualización en pantalla completa.
- Captura de imágenes mediante `UIImagePickerController` (UIKit bridge).
- Persistencia de:
  - id / secuencia
  - nombre
  - fecha
  - imagen (BLOB)

### Generación de nombre
- Formato: `photo-001`, `photo-002`, …
- Basado en el **mayor consecutivo almacenado**, evitando colisiones.

### Permisos
- Declaración de `NSCameraUsageDescription` en `Info.plist`.
- Manejo del flujo si la cámara no está disponible o el permiso es denegado.

---

## 💾 Base de datos (SQLite)

Se decidió utilizar **SQLite3 directamente** en lugar de Core Data por:

- Control explícito del esquema.
- Manejo claro de BLOBs (imágenes).
- Menor complejidad para el alcance de la prueba.
- Mayor visibilidad de la lógica de persistencia.

Características:
- Inicialización segura.
- Acceso thread-safe mediante cola serial.
- Uso de transacciones explícitas.
- Manejo controlado de errores.

---

## 📦 Librerías utilizadas

No se utilizaron librerías externas.

El proyecto utiliza únicamente:
- SwiftUI
- Foundation
- SQLite3
- UIKit (limitado al uso de `ImagePicker`)

Esta decisión se tomó para mantener el proyecto simple y fácil de evaluar.

---

## 🧪 Pasos de prueba sugeridos

1. Ejecutar la aplicación.
2. Validar la pantalla de control de versión.
3. Iniciar sesión con las credenciales provistas.
4. Verificar acceso al Home.
5. Cerrar la app y volver a abrir para validar persistencia.
6. Probar el módulo de Localidades.
7. Probar el módulo de Fotos:
   - Capturar una imagen.
   - Ver la lista de fotos.
   - Visualizar una foto en pantalla completa.
8. Ejecutar Logout y validar retorno a Login.

---

## 🧠 Supuestos y trade-offs

- Los servicios remotos pueden no estar disponibles → se manejan fallbacks.
- Se priorizó estabilidad y claridad sobre diseño visual avanzado.
- Se evitó sobre-arquitectura innecesaria para el alcance de la prueba.

---

## ✅ Conclusión

La solución presentada cumple con los requisitos funcionales y técnicos solicitados, demostrando un manejo adecuado de SwiftUI, persistencia local, control de estado y una arquitectura clara y mantenible.

El proyecto está preparado para ser evaluado y defendido técnicamente.
