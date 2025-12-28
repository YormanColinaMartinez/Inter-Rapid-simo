//
//  SchemaRepositoryImpl.swift
//  Inter Rapidísimo
//
//  Created by mac on 25/12/25.
//

import Foundation

final class SchemaRepositoryImpl: SchemaRepository {

    private let api: APIClientProtocol

    init(api: APIClientProtocol) {
        self.api = api
    }

    func fetchSchema() async throws -> [SchemaTableDTO] {
        let url = URL(string:
            "https://apitesting.interrapidisimo.co/apicontrollerpruebas/api/SincronizadorDatos/ObtenerEsquema/true"
        )!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return try await api.request(request)
    }
}
