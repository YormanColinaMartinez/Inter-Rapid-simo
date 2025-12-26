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
            "https://apitesting.interrapidisimo.co/FtEntregaElectronica/MultiCanales/ApiSeguridadPruebas/api/Seguridad/ObtenerLocalidadesRecogidas"
        )!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dtos: [LocalityDTO] = try await api.request(request)
        
        let locals = dtos.map {
            Locality(id: $0.id, name: $0.name)
        }
        
        try await db.saveLocalities(locals)
        return locals
    }

    func fetchLocal() async throws -> [Locality] {
        try await db.fetchLocalities()
    }
}
