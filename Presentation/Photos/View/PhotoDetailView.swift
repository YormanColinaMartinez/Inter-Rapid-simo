//
//  PhotoDetailView.swift
//  Inter Rapidísimo
//
//  Created by mac on 26/12/25.
//

import SwiftUI

struct PhotoDetailView: View {

    let photo: Photo

    var body: some View {
        VStack {
            if let image = UIImage(data: photo.imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .navigationTitle(photo.name)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("No se pudo cargar la imagen")
                    .foregroundColor(.gray)
            }
        }
        .background(Color.black.opacity(0.9))
    }
}
