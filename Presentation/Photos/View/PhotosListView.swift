//
//  PhotosListView.swift
//  Inter Rapidísimo
//
//  Created by mac on 26/12/25.
//

import SwiftUI

struct PhotosListView: View {
    
    @StateObject private var viewModel = PhotosViewModel()
    
    var body: some View {
        ZStack {
            // Dark background
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                containerView
                
                // MARK: - Bottom Action Bar
                VStack(spacing: 0) {
                    Divider()
                        .background(Color(white: 0.3))
                    
                    HStack(spacing: 20) {
                        // Camera Button
                        Button {
                            Task {
                                await viewModel.requestCameraAccess()
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Tomar Foto")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(white: 0.15))
                            )
                        }
                        
                        // View Photo Button
                        Button {
                            if viewModel.selectedPhoto != nil {
                                viewModel.showDetail = true
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Ver Foto")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(viewModel.selectedPhoto != nil ? 
                                          LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.2, green: 0.5, blue: 1.0),
                                                Color(red: 0.0, green: 0.4, blue: 0.9)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                          ) : 
                                          LinearGradient(
                                            gradient: Gradient(colors: [Color(white: 0.15)]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                          )
                                    )
                            )
                        }
                        .disabled(viewModel.selectedPhoto == nil)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.black)
                }
            }
            .navigationTitle("Fotos")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .onAppear {
                Task {
                    await viewModel.loadPhotos()
                }
            }
            .sheet(isPresented: $viewModel.showCamera) {
                if CameraPermissionManager.isCameraAvailable() {
                    ImagePicker(sourceType: .camera) { image in
                        Task {
                            await viewModel.saveImage(image)
                            viewModel.selectedPhoto = nil
                        }
                    }
                } else {
                    ImagePicker(sourceType: .photoLibrary) { image in
                        Task {
                            await viewModel.saveImage(image)
                            viewModel.selectedPhoto = nil
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.showDetail) {
                if let photo = viewModel.selectedPhoto {
                    PhotoDetailView(photo: photo)
                }
            }
            .alert("Permisos de cámara", isPresented: $viewModel.showPermissionAlert) {
                Button("Aceptar", role: .cancel) {}
                Button("Configuración") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            } message: {
                Text(viewModel.errorMessage ?? "Se necesita acceso a la cámara para tomar fotos.")
            }
        }
    }
    
    private var containerView: some View {
        Group {
            if viewModel.photos.isEmpty {
                emptyView
            } else {
                listView
            }
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 48))
                .foregroundColor(Color(white: 0.4))
            Text("No hay fotos guardadas")
                .font(.system(size: 16))
                .foregroundColor(Color(white: 0.6))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var listView: some View {
        List {
            ForEach(viewModel.photos) { photo in
                PhotoRowView(
                    isSelected: viewModel.selectedPhoto?.id == photo.id,
                    photo: photo
                )
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .contentShape(Rectangle())
                .onTapGesture {
                    // Toggle selection: if already selected, deselect; otherwise select
                    if viewModel.selectedPhoto?.id == photo.id {
                        viewModel.selectedPhoto = nil
                    } else {
                        viewModel.selectedPhoto = photo
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}
