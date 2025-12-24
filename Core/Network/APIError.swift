//
//  APIError.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidResponse
    case statusCode(Int)
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Respuesta inválida del servidor."
        case .statusCode(let code):
            return "Error del servidor. Código HTTP: \(code)"
        case .decoding:
            return "No se pudo interpretar la respuesta del servidor."
        }
    }
}
