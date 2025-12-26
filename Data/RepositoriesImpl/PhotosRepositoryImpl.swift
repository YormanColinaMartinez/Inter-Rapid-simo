//
//  PhotosRepositoryImpl.swift
//  Inter Rapidísimo
//
//  Created by mac on 26/12/25.
//

import Foundation

final class PhotoRepositoryImpl: PhotoRepository {

    private let db = SQLiteManager.shared

    func save(photo: Photo) async throws {
        try await db.savePhoto(photo)
    }

    func fetchAll() async throws -> [Photo] {
        try await db.fetchPhotos()
    }
}
