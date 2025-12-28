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

    func login(username: String, password: String) async throws -> User {
        guard !username.isEmpty, !password.isEmpty else {
            throw NSError(domain: "AuthError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Usuario y contraseña son requeridos"])
        }
        
        let url = URL(string:
            "https://apitesting.interrapidisimo.co/FtEntregaElectronica/MultiCanales/ApiSeguridadPruebas/api/Seguridad/AuthenticaUsuarioApp"
        )!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Usar los valores del formulario en los headers
        request.addValue(username, forHTTPHeaderField: "Usuario")
        request.addValue(password, forHTTPHeaderField: "Identificacion")
        request.addValue("text/json", forHTTPHeaderField: "Accept")
        request.addValue(username, forHTTPHeaderField: "IdUsuario")
        request.addValue("1295", forHTTPHeaderField: "IdCentroServicio")
        request.addValue("PTO/BOGOTA/CUND/COL/OF PRINCIPAL - CRA 30 # 7-45",forHTTPHeaderField: "NombreCentroServicio")
        request.addValue("9", forHTTPHeaderField: "IdAplicativoOrigen")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Codificar password en base64 para el body
        let passwordBase64 = password.data(using: .utf8)?.base64EncodedString() ?? ""
        let usernameBase64 = username.data(using: .utf8)?.base64EncodedString() ?? ""
        
        let body: [String: String] = [
            "Mac": "",
            "NomAplicacion": "Controller APP",
            "Password": passwordBase64,
            "Path": "",
            "Usuario": usernameBase64
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
