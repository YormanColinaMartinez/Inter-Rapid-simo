//
//  SQLiteError.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import Foundation

enum SQLiteError: Error, LocalizedError {
    case openDatabase(message: String)
    case prepare(message: String)
    case step(message: String)
    case close(message: String)
    
    var errorDescription: String? {
        switch self {
        case .openDatabase(let message):
            return "No se pudo abrir la base de datos: \(message)"
        case .prepare(let message):
            return "Error preparando sentencia SQL: \(message)"
        case .step(let message):
            return "Error ejecutando sentencia SQL: \(message)"
        case .close(let message):
            return "Error cerrando base de datos: \(message)"
        }
    }
}
