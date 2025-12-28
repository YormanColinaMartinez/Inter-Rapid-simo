//
//  HomeCard.swift
//  Inter Rapidísimo
//
//  Created by mac on 26/12/25.
//

import SwiftUI

struct HomeCard<Destination: View>: View {

    let title: String
    let subtitle: String
    let systemImage: String
    let destination: Destination

    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack(spacing: 16) {

                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundColor(.accentColor)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .buttonStyle(.plain)
    }
}
