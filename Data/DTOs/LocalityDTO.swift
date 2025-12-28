//
//  LocalityDTO.swift
//  Inter Rapidísimo
//
//  Created by mac on 25/12/25.
//

import Foundation

struct LocalityDTO: Decodable {
    let abreviacionCiudad: String
    let nombreCompleto: String
    
    enum CodingKeys: String, CodingKey {
        case abreviacionCiudad = "AbreviacionCiudad"
        case nombreCompleto = "NombreCompleto"
    }
}
