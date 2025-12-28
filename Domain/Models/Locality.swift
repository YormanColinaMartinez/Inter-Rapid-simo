//
//  Locality.swift
//  Inter Rapidísimo
//
//  Created by mac on 25/12/25.
//

import Foundation

struct Locality: Identifiable {
    let id: Int
    let abreviacionCiudad: String
    let nombreCompleto: String
    
    var name: String {
        return nombreCompleto
    }
}
