//
//  SchemaRepository.swift
//  Inter Rapidísimo
//
//  Created by mac on 25/12/25.
//

import Foundation

protocol SchemaRepository {
    func fetchSchema() async throws -> [SchemaTableDTO]
}
