//
//  PhotoRowView.swift
//  Inter Rapidísimo
//
//  Created by mac on 26/12/25.
//

import SwiftUI

struct PhotoRowView: View {

    let photo: Photo

    var body: some View {
        HStack(spacing: 12) {
            if let uiImage = UIImage(data: photo.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipped()
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(photo.name)
                    .font(.headline)

                Text(photo.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}
