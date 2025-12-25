//
//  VersionRepository.swift
//  Inter Rapidísimo
//
//  Created by mac on 24/12/25.
//

import Foundation

protocol VersionRepository {
    func validateVersion() async throws -> AppVersionDTO
}
