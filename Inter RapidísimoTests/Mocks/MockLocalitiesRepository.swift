//
//  MockLocalitiesRepository.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import Foundation
@testable import Inter_Rapidísimo

final class MockLocalitiesRepository: LocalitiesRepository {
    
    var mockLocalities: [Locality] = []
    var shouldFailRemote = false
    var shouldFailLocal = false
    var remoteError: Error?
    var localError: Error?
    
    func fetchRemote() async throws -> [Locality] {
        if shouldFailRemote {
            throw remoteError ?? APIError.invalidResponse
        }
        return mockLocalities
    }
    
    func fetchLocal() async throws -> [Locality] {
        if shouldFailLocal {
            throw localError ?? SQLiteError.openDatabase(message: "Mock error")
        }
        return mockLocalities
    }
}

