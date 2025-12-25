//
//  APIClient.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import Foundation

final class APIClient: APIClientProtocol {
    
    func request<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard 200..<300 ~= http.statusCode else {
            throw APIError.statusCode(http.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
    
    func requestPlain(_ request: URLRequest) async throws -> String {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard 200..<300 ~= http.statusCode else {
            throw APIError.statusCode(http.statusCode)
        }

        guard let value = String(data: data, encoding: .utf8) else {
            throw APIError.decoding(NSError(domain: "Empty plain response", code: 0))
        }

        return value
    }

}
