//
//  VersionRepositoryImpl.swift
//  Inter Rapidísimo
//
//  Created by mac on 24/12/25.
//

import Foundation

final class VersionRepositoryImpl: VersionRepository {
    private let api: APIClientProtocol
    
    init(api: APIClientProtocol) {
        self.api = api
    }
    
    func validateVersion() async throws -> AppVersionDTO {
        let url = URL(string:
            "https://apitesting.interrapidisimo.co/apicontrollerpruebas/api/ParametrosFramework/ConsultarParametrosFramework/VPStoreAppControl"
        )!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let remoteVersion = try await api.requestPlain(request)
        
        return AppVersionDTO(version: remoteVersion)
    }
}
