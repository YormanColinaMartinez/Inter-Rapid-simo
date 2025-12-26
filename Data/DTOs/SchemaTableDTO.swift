//
//  SchemaTableDTO.swift
//  Inter Rapidísimo
//
//  Created by mac on 25/12/25.
//

import Foundation

struct SchemaTableDTO: Decodable {
    let nombreTabla: String
    let descripcion: String?

    enum CodingKeys: String, CodingKey {
        case nombreTabla = "NombreTabla"
        case descripcion = "Descripcion"
    }
}
