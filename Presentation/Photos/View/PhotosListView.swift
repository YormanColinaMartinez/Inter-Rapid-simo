//
//  PhotosListView.swift
//  Inter Rapidísimo
//
//  Created by mac on 26/12/25.
//

import SwiftUI

struct PhotosListView: View {
    
    @StateObject private var viewModel = PhotosViewModel()
    
    var body: some View {
        VStack {
            containerView
            
            .navigationTitle("Fotos")
            .onAppear {
                Task {
                    await viewModel.loadPhotos()
                }
            }
            .safeAreaInset(edge: .bottom) {
                buttomView
                .padding()
                .background(.ultraThinMaterial)
            }
            .sheet(isPresented: $viewModel.showCamera) {
                ImagePicker(sourceType: .camera) { image in
                    Task {
                        await viewModel.saveImage(image)
                        viewModel.selectedPhoto = nil
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.showDetail) {
                if let photo = viewModel.selectedPhoto {
                    PhotoDetailView(photo: photo)
                }
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
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text("No hay fotos guardadas")
                .foregroundColor(.gray)
        }
    }
    
    private var listView: some View {
        List(viewModel.photos) { photo in
            PhotoRowView(isSelected: viewModel.selectedPhoto?.id == photo.id, photo: photo)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.selectedPhoto = photo
                }
        }
    }
    
    private var buttomView: some View {
        HStack(spacing: 40) {
            
            Button {
                viewModel.showCamera = true
            } label: {
                Image(systemName: "camera")
                    .font(.title2)
            }
            
            Button {
                if viewModel.selectedPhoto != nil {
                    viewModel.showDetail = true
                }
            } label: {
                Image(systemName: "photo")
                    .font(.title2)
            }
            .disabled(viewModel.selectedPhoto == nil)
        }
    }
}
