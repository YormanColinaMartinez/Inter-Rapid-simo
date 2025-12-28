//
//  LocalitiesRepositoryImpl.swift
//  Inter Rapidísimo
//
//  Created by mac on 25/12/25.
//

import Foundation

final class LocalitiesRepositoryImpl: LocalitiesRepository {

    private let api: APIClientProtocol
    private let db = SQLiteManager.shared

    init(api: APIClientProtocol) {
        self.api = api
    }

    func fetchRemote() async throws -> [Locality] {
        let url = URL(string:
            "https://apitesting.interrapidisimo.co/apicontrollerpruebas/api/ParametrosFramework/ObtenerLocalidadesRecogidas"
        )!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dtos: [LocalityDTO] = try await api.request(request)
        
        let locals = dtos.enumerated().map { index, dto in
            Locality(
                id: index + 1,
                abreviacionCiudad: dto.abreviacionCiudad,
                nombreCompleto: dto.nombreCompleto
            )
        }
        
        try await db.saveLocalities(locals)
        return locals
    }

    func fetchLocal() async throws -> [Locality] {
        try await db.fetchLocalities()
    }
}
