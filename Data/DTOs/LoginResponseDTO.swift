//
//  LoginResponseDTO.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import Foundation

struct LoginResponseDTO: Decodable {
    let username: String
    let identification: String?
    let firstName: String?
    let lastName1: String?
    let lastName2: String?
    let role: String?
    let resultMessage: Int
    let token: String?

    enum CodingKeys: String, CodingKey {
        case username = "Usuario"
        case identification = "Identificacion"
        case firstName = "Nombre"
        case lastName1 = "Apellido1"
        case lastName2 = "Apellido2"
        case role = "Cargo"
        case resultMessage = "MensajeResultado"
        case token = "TokenJWT"
    }
}

