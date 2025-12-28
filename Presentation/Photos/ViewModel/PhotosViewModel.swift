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
    @Published var showPermissionAlert = false

    private let repo: PhotoRepository

    init(repo: PhotoRepository = PhotoRepositoryImpl()) {
        self.repo = repo
    }
    
    func requestCameraAccess() async {
        let status = CameraPermissionManager.checkPermission()
        
        switch status {
        case .authorized:
            showCamera = true
        case .denied, .restricted:
            showPermissionAlert = true
            errorMessage = "El acceso a la cámara está denegado. Por favor, habilítalo en Configuración."
        case .notDetermined:
            let granted = await CameraPermissionManager.requestPermission()
            if granted {
                showCamera = true
            } else {
                showPermissionAlert = true
                errorMessage = "Se necesita acceso a la cámara para tomar fotos."
            }
        }
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
