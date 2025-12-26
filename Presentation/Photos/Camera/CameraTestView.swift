//
//  CameraTestView.swift
//  Inter Rapidísimo
//
//  Created by mac on 26/12/25.
//

// ESTA VISTA ES TEMPORAL, NO DEBE QUEDAR PARA FINES DE LA PRUEBA

import SwiftUI

struct CameraTestView: View {

    @StateObject private var viewModel = PhotosViewModel()
    @State private var showCamera = false
    @State private var capturedImage: UIImage?

    var body: some View {
        VStack {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }

            Button("Abrir cámara") {
                showCamera = true
            }
        }
        .sheet(isPresented: $showCamera) {
            let source: UIImagePickerController.SourceType =
                UIImagePickerController.isSourceTypeAvailable(.camera)
                ? .camera
                : .photoLibrary

            ImagePicker(sourceType: source) { image in
                self.capturedImage = image
                Task {
                    await viewModel.saveImage(image)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadPhotos()
            }
        }
        .navigationTitle("Test Cámara")
    }
}
