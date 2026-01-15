# 📱 Inter Rapidísimo – Prueba Técnica iOS

---

## Cómo correr el proyecto

### Requisitos
- Xcode 15+
- iOS 16+
- Dispositivo físico recomendado para pruebas de cámara

### Pasos
1. Clonar el repositorio
2. Abrir `.xcodeproj` en Xcode
3. Seleccionar simulador o dispositivo
4. Ejecutar (`⌘R`)

> Para el módulo de fotos, usar **dispositivo físico**. En simulador se habilita selección desde galería.

---

## Arquitectura

**MVVM** con separación por capas:

- **Presentation**: Views (SwiftUI) + ViewModels (@MainActor)
- **Domain**: Models + Repositories (protocolos)
- **Data**: DTOs + Implementaciones de repositorios + SQLiteManager

### Decisiones clave

**1. async/await sobre Combine**
- Sintaxis más clara y legible para operaciones asíncronas
- Mejor integración con SwiftUI y APIs modernas de iOS
- Menor complejidad para el alcance de la prueba
- Manejo de errores más directo con `try/catch`

**2. SQLite3 nativo sobre Core Data**
- Control explícito del esquema y queries
- Manejo directo de BLOBs (imágenes)
- Menor overhead y mayor visibilidad de la lógica
- Sin dependencias adicionales

**3. Navegación centralizada en RootView**
- Evita estados duplicados y navegación imperativa
- Flujo de autenticación más predecible
- Facilita testing y mantenimiento

---

## Requisitos implementados

### 1. Capa de Seguridad

**1.1 Control de versiones**
- GET endpoint de versión remota
- Comparación con `CFBundleShortVersionString`
- Alertas para versión menor/mayor/igual
- Manejo de errores de red

**1.2 Login**
- POST con headers y body dinámicos desde formulario
- Validación de campos requeridos
- Persistencia de usuario autenticado
- Restauración automática de sesión

### 2. Capa de Datos (SQLite)

**Persistencia local:**
- Usuario autenticado (usuario, identificación, nombre)
- Tablas del sincronizador (schema_tables)
- Fotos (BLOB + metadatos: seq, name, date)
- Localidades (fallback local)

**2.1 Sincronizador de tablas**
- GET endpoint de esquema
- Persistencia en tabla local `schema_tables`
- Sincronización automática al cargar

### 3. Capa de Presentación (SwiftUI)

**3.1 HOME**
- Muestra usuario, identificación y nombre desde SQLite
- Navegación a Tablas, Localidades y Fotos
- Logout funcional

**3.2 TABLAS**
- Lista de tablas desde SQLite
- Estados: loading/empty/error
- Sincronización automática

**3.3 LOCALIDADES**
- GET endpoint de localidades
- Muestra AbreviacionCiudad y NombreCompleto
- Fallback local si el servicio falla

**3.4 FOTOS**
- Lista vertical con miniatura y nombre
- Barra inferior fija con botones descriptivos
- Captura con cámara (permisos manejados)
- Visualización en pantalla completa con zoom
- Generación automática de nombres (photo-001, photo-002...)
- Persistencia: id/seq, nombre, fecha, BLOB

---

## 🔧 Detalles técnicos

### Networking
- `APIClient` con async/await
- Timeouts configurados (30s request, 60s resource)
- Manejo de códigos HTTP y errores de parsing
- Cliente específico para respuestas planas (versión)

### Base de datos
- Thread-safe con cola serial
- Transacciones explícitas
- Escape de caracteres especiales (SQL injection prevention)
- Tests unitarios para operaciones principales

### Permisos
- `NSCameraUsageDescription` en Info.plist
- `NSPhotoLibraryUsageDescription` para galería
- Manejo de estados: authorized/denied/restricted/notDetermined
- Alertas y navegación a Configuración

### Estados UI
- Loading: ProgressView con mensajes descriptivos
- Empty: Vistas vacías con iconos y mensajes
- Error: Mensajes de error claros y accionables

---

## Dependencias

**Ninguna librería externa.**

Utiliza únicamente:
- SwiftUI
- Foundation
- SQLite3 (nativo)
- UIKit (solo ImagePicker bridge)

**Justificación**: Mantener el proyecto simple, evaluable y sin dependencias externas que puedan complicar la revisión.

---

## Testing

**Tests unitarios incluidos:**
- SQLiteManager (CRUD de usuarios, fotos, localidades)
- ViewModels (Login, Version, Home, etc.)
- DTOs (parsing de respuestas)
- Comparación de versiones

**Cobertura:**
- Operaciones críticas de base de datos
- Lógica de negocio en ViewModels
- Validaciones y manejo de errores

---

## Supuestos y trade-offs

1. **Servicios remotos pueden fallar** → Fallbacks locales implementados
2. **Versión del endpoint retorna texto plano** → Cliente específico para manejar esto
3. **Localidades pueden retornar 401/404** → Persistencia local como fallback
4. **Prioridad: estabilidad > diseño visual** → UI funcional y clara, no sofisticada
5. **Sin sobre-arquitectura** → MVVM simple y directo para el alcance de la prueba

---

## Estructura del proyecto

```
Inter Rapidísimo/
├── App/                    # Entry point
├── Core/                   # Utilidades compartidas
│   ├── Database/          # SQLiteManager
│   ├── Network/           # APIClient
│   └── Utils/             # Helpers
├── Data/                   # Capa de datos
│   ├── DTOs/              # Data Transfer Objects
│   └── RepositoriesImpl/  # Implementaciones
├── Domain/                 # Capa de dominio
│   ├── Models/            # Entidades
│   └── Repositories/      # Protocolos
└── Presentation/          # Capa de presentación
    ├── Home/
    ├── Login/
    ├── Version/
    ├── Tables/
    ├── Localidades/
    └── Photos/
```

---


El proyecto está listo para evaluación técnica.
