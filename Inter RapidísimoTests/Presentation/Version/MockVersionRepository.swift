//
//  MockVersionRepository.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//
import Foundation
@testable import Inter_Rapidísimo

final class MockVersionRepository: VersionRepository {

    var version: String
    var shouldFail: Bool

    init(version: String, shouldFail: Bool = false) {
        self.version = version
        self.shouldFail = shouldFail
    }

    func validateVersion() async throws -> AppVersionDTO {
        if shouldFail {
            throw URLError(.badServerResponse)
        }
        return AppVersionDTO(version: version)
    }
}
