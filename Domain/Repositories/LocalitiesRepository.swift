//
//  LocalitiesRepository.swift
//  Inter Rapidísimo
//
//  Created by mac on 25/12/25.
//

import Foundation

protocol LocalitiesRepository {
    func fetchRemote() async throws -> [Locality]
    func fetchLocal() async throws -> [Locality]
}
