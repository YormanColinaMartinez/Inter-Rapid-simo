//
//  MockSchemaRepository.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import Foundation
@testable import Inter_Rapidísimo

final class MockSchemaRepository: SchemaRepository {
    
    var mockTables: [SchemaTableDTO] = []
    var shouldFail = false
    var error: Error?
    
    func fetchSchema() async throws -> [SchemaTableDTO] {
        if shouldFail {
            throw error ?? APIError.invalidResponse
        }
        return mockTables
    }
}

