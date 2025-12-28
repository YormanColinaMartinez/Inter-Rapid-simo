//
//  MockAuthRepository.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import Foundation
@testable import Inter_Rapidísimo

final class MockAuthRepository: AuthRepository {
    
    var shouldFail = false
    var error: Error?
    var mockUser: User?
    
    init(shouldFail: Bool = false, error: Error? = nil, mockUser: User? = nil) {
        self.shouldFail = shouldFail
        self.error = error
        self.mockUser = mockUser
    }
    
    func login(username: String, password: String) async throws -> User {
        if shouldFail {
            throw error ?? APIError.invalidResponse
        }
        return mockUser ?? User(user: "test.user", id: "123456789", name: "Test User")
    }
}
