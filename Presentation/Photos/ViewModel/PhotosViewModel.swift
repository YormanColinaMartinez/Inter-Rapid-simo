//
//  PhotosViewModel.swift
//  Inter Rapidísimo
//
//  Created by mac on 26/12/25.
//

import SwiftUI

@MainActor
final class PhotosViewModel: ObservableObject {
    @Published var selectedPhoto: Photo?
    @Published var showCamera = false
    @Published var showDetail = false
    @Published var photos: [Photo] = []
    @Published var errorMessage: String?

    private let repo: PhotoRepository

    init(repo: PhotoRepository = PhotoRepositoryImpl()) {
        self.repo = repo
    }

    func saveImage(_ image: UIImage) async {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }

        do {
            let seq = try await repo.nextSequence()

            let photo = Photo(
                id: 0,
                name: String(format: "photo-%03d", seq),
                date: Date(),
                imageData: data
            )

            try await repo.save(photo: photo)
            await loadPhotos()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadPhotos() async {
        do {
            photos = try await repo.fetchAll()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
