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
        Group {
            if viewModel.photos.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("No hay fotos guardadas")
                        .foregroundColor(.gray)
                }
            } else {
                List(viewModel.photos) { photo in
                    NavigationLink {
                        PhotoDetailView(photo: photo)
                    } label: {
                        PhotoRowView(photo: photo)
                    }
                }
            }
        }
        .navigationTitle("Fotos")
        .onAppear {
            Task {
                await viewModel.loadPhotos()
            }
        }
    }
}
