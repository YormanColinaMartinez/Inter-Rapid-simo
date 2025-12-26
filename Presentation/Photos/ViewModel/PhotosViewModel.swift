//
//  PhotosViewModel.swift
//  Inter Rapidísimo
//
//  Created by mac on 26/12/25.
//

import SwiftUI

@MainActor
final class PhotosViewModel: ObservableObject {

    @Published var photos: [Photo] = []
    @Published var errorMessage: String?

    private let repo: PhotoRepository

    init(repo: PhotoRepository = PhotoRepositoryImpl()) {
        self.repo = repo
    }

    // 🔹 Guardar foto tomada
    func saveImage(_ image: UIImage) async {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }

        do {
            let nextName = try await generateNextPhotoName()

            let photo = Photo(
                id: nil,
                name: nextName,
                date: Date(),
                imageData: data
            )

            try await repo.save(photo: photo)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // 🔹 Cargar desde SQLite
    func loadPhotos() async {
        do {
            photos = try await repo.fetchAll()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // 🔹 Nombre secuencial requerido por la prueba
    private func generateNextPhotoName() async throws -> String {
        let existing = try await repo.fetchAll()
        return "photo_\(existing.count + 1)"
    }
}
