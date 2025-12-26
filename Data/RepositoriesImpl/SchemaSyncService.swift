//
//  SchemaSyncService.swift
//  Inter Rapidísimo
//
//  Created by mac on 25/12/25.
//

import Foundation

final class SchemaSyncService {

    private let remote: SchemaRepository
    private let local: SchemaLocalRepositoryImpl

    init(remote: SchemaRepository,
         local: SchemaLocalRepositoryImpl) {
        self.remote = remote
        self.local = local
    }

    func sync() async throws {
        let tables = try await remote.fetchSchema()
        try await local.saveAll(tables)
    }
}
