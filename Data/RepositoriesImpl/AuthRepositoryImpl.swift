//
//  AuthRepositoryImpl.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import Foundation

final class AuthRepositoryImpl: AuthRepository {

    private let api: APIClientProtocol

    init(api: APIClientProtocol) {
        self.api = api
    }

    func login() async throws -> User {
        let url = URL(string:
            "https://apitesting.interrapidisimo.co/FtEntregaElectronica/MultiCanales/ApiSeguridadPruebas/api/Seguridad/AuthenticaUsuarioApp"
        )!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.addValue("pam.meredy21", forHTTPHeaderField: "Usuario")
        request.addValue("987204545", forHTTPHeaderField: "Identificacion")
        request.addValue("text/json", forHTTPHeaderField: "Accept")
        request.addValue("pam.meredy21", forHTTPHeaderField: "IdUsuario")
        request.addValue("1295", forHTTPHeaderField: "IdCentroServicio")
        request.addValue("PTO/BOGOTA/CUND/COL/OF PRINCIPAL - CRA 30 # 7-45",
                         forHTTPHeaderField: "NombreCentroServicio")
        request.addValue("9", forHTTPHeaderField: "IdAplicativoOrigen")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "Mac": "",
            "NomAplicacion": "Controller APP",
            "Password": "SW50ZXIyMDIx",
            "Path": "",
            "Usuario": "cGFtLm1lcmVkeTIx"
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let dto: LoginResponseDTO = try await api.request(request)

        return User(
            user: dto.username,
            id: dto.identification ?? "",
            name: dto.firstName ?? ""
        )
    }
}
