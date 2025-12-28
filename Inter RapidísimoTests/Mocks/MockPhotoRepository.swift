//
//  MockPhotoRepository.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import Foundation
@testable import Inter_Rapidísimo

final class MockPhotoRepository: PhotoRepository {
    
    var savedPhotos: [Photo] = []
    var nextSeq = 1
    var shouldFail = false
    var error: Error?
    
    func save(photo: Photo) async throws {
        if shouldFail {
            throw error ?? SQLiteError.openDatabase(message: "Mock error")
        }
        savedPhotos.append(photo)
    }
    
    func fetchAll() async throws -> [Photo] {
        if shouldFail {
            throw error ?? SQLiteError.openDatabase(message: "Mock error")
        }
        return savedPhotos
    }
    
    func nextSequence() async throws -> Int {
        if shouldFail {
            throw error ?? SQLiteError.openDatabase(message: "Mock error")
        }
        let current = nextSeq
        nextSeq += 1
        return current
    }
}

