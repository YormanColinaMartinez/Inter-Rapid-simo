//
//  PhotosRepositoryImpl.swift
//  Inter Rapidísimo
//
//  Created by mac on 26/12/25.
//

import Foundation

final class PhotoRepositoryImpl: PhotoRepository {

    private let db = SQLiteManager.shared

    func nextSequence() async throws -> Int {
        try await db.nextPhotoSequence()
    }

    func save(photo: Photo) async throws {
        let seq = try await nextSequence()
        try await db.savePhoto(photo, seq: seq)
    }

    func fetchAll() async throws -> [Photo] {
        try await db.fetchPhotos()
    }
}
