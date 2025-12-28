//
//  Strings.swift
//  Inter Rapidísimo
//
//  Created by mac on 26/12/25.
//

import Foundation

// MARK: - Localized Strings

struct Strings {
    
    // MARK: - App
    struct App {
        static let name = "Inter Rapidísimo"
        static let nameInter = "Inter"
        static let nameRapidisimo = "Rapidisimo"
        static let logoSymbol = "S"
    }
    
    // MARK: - Login
    struct Login {
        static let title = "Iniciar Sesión"
        static let usernamePlaceholder = "Nombre de usuario"
        static let passwordPlaceholder = "Contraseña"
        static let loginButton = "Ingresar"
        static let loginButtonPrefix = "+"
        static let forgotPassword = "¿Olvidaste tu contraseña?"
        static let emptyCredentialsError = "Por favor ingresa usuario y contraseña"
        static let requiredFieldsError = "Usuario y contraseña son requeridos"
    }
    
    // MARK: - Home
    struct Home {
        static let welcomeBack = "Bienvenido de nuevo"
        static let user = "Usuario"
        static let identification = "Identificación"
        static let logout = "Cerrar Sesión"
        static let tablesTitle = "Tablas"
        static let tablesSubtitle = "Consulta y gestión de esquemas de datos"
        static let localitiesTitle = "Localidades"
        static let localitiesSubtitle = "Visualización de localidades disponibles"
        static let photosTitle = "Fotos"
        static let photosSubtitle = "Captura y almacenamiento de imágenes"
    }
    
    // MARK: - Version
    struct Version {
        static let validating = "Validando versión..."
        static let title = "Control de versión"
        static let newVersionAvailable = "Hay una nueva versión disponible (%@). Por favor actualiza la app."
        static let inconsistentVersion = "La versión instalada (%@) es superior a la del servidor (%@). Ambiente inconsistente."
    }
    
    // MARK: - Tables
    struct Tables {
        static let title = "Tablas"
        static let loading = "Cargando esquema..."
        static let empty = "No hay tablas para mostrar."
    }
    
    // MARK: - Localities
    struct Localities {
        static let title = "Localidades"
        static let loading = "Cargando localidades..."
        static let empty = "No hay localidades disponibles"
    }
    
    // MARK: - Photos
    struct Photos {
        static let title = "Fotos"
        static let empty = "No hay fotos guardadas"
        static let takePhoto = "Tomar Foto"
        static let viewPhoto = "Ver Foto"
        static let cameraPermissionTitle = "Permisos de cámara"
        static let cameraPermissionDenied = "El acceso a la cámara está denegado. Por favor, habilítalo en Configuración."
        static let cameraPermissionRequired = "Se necesita acceso a la cámara para tomar fotos."
        static let settings = "Configuración"
        static let accept = "Aceptar"
        static let close = "Cerrar"
        static let imageLoadError = "No se pudo cargar la imagen"
    }
    
    // MARK: - Common
    struct Common {
        static let accept = "Aceptar"
        static let cancel = "Cancelar"
        static let close = "Cerrar"
        static let error = "Error"
        static let loading = "Cargando..."
    }
    
    // MARK: - Errors
    struct Errors {
        static let databaseNotInitialized = "Database not initialized"
        static let unknownSQLiteError = "Unknown SQLite error"
        static let emptyPlainResponse = "Empty plain response"
    }
}
