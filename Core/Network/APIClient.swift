//
//  APIClient.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import Foundation

final class APIClient: APIClientProtocol {
    
    func request<T>(_ request: URLRequest) async throws -> T where T : Decodable {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        #if DEBUG
        if let raw = String(data: data, encoding: .utf8) {
            print("📦 RAW RESPONSE:\n", raw)
        }
        #endif
        
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard 200..<300 ~= http.statusCode else {
            #if DEBUG
            print("❌ HTTP Status:", http.statusCode)
            #endif
            throw APIError.statusCode(http.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch  {
            throw APIError.decoding(error)
        }
    }
}
