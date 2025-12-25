//
//  APIClientProtocol.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(_ request: URLRequest) async throws -> T
    func requestPlain(_ request: URLRequest) async throws -> String
}
