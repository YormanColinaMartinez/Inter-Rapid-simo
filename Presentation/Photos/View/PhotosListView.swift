//
//  PhotosListView.swift
//  Inter Rapidísimo
//
//  Created by mac on 26/12/25.
//

import SwiftUI

// MARK: - PhotosListView

struct PhotosListView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = PhotosViewModel()
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                containerView
                
                // MARK: - Bottom Action Bar
                bottomActionBar
            }
            .navigationTitle(Strings.Photos.title)
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .onAppear {
                Task {
                    await viewModel.loadPhotos()
                }
            }
            .sheet(isPresented: $viewModel.showCamera) {
                cameraSheet
            }
            .fullScreenCover(isPresented: $viewModel.showDetail) {
                if let photo = viewModel.selectedPhoto {
                    PhotoDetailView(photo: photo)
                }
            }
            .alert(Strings.Photos.cameraPermissionTitle, isPresented: $viewModel.showPermissionAlert) {
                Button(Strings.Common.accept, role: .cancel) {}
                Button(Strings.Photos.settings) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            } message: {
                Text(viewModel.errorMessage ?? Strings.Photos.cameraPermissionRequired)
            }
        }
    }
    
    // MARK: - View Components
    
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
            Text(Strings.Photos.empty)
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
    
    private var bottomActionBar: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color(white: 0.3))
            
            HStack(spacing: 20) {
                Button {
                    Task {
                        await viewModel.requestCameraAccess()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 18, weight: .semibold))
                        Text(Strings.Photos.takePhoto)
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
                
                Button {
                    if viewModel.selectedPhoto != nil {
                        viewModel.showDetail = true
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 18, weight: .semibold))
                        Text(Strings.Photos.viewPhoto)
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
    
    private var cameraSheet: some View {
        Group {
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
    }
}
