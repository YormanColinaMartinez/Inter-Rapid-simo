//
//  MockUserRepository.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import Foundation
@testable import Inter_Rapidísimo

final class MockUserRepository: UserRepository {
    
    var savedUser: User?
    var shouldFail = false
    var error: Error?
    
    func save(user: User) async throws {
        if shouldFail {
            throw error ?? SQLiteError.openDatabase(message: "Mock error")
        }
        savedUser = user
    }
    
    func getUser() async throws -> User? {
        if shouldFail {
            throw error ?? SQLiteError.openDatabase(message: "Mock error")
        }
        return savedUser
    }
    
    func deleteAll() async throws {
        if shouldFail {
            throw error ?? SQLiteError.openDatabase(message: "Mock error")
        }
        savedUser = nil
    }
}

