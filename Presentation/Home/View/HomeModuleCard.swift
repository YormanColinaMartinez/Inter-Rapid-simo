//
//  HomeModuleCard.swift
//  Inter Rapidísimo
//
//  Created by mac on 28/12/25.
//

import SwiftUI

struct HomeModuleCard<Destination: View>: View {

    let title: String
    let subtitle: String
    let systemImage: String
    let tint: Color
    let destination: Destination

    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack(spacing: 16) {

                Image(systemName: systemImage)
                    .font(.system(size: 24))
                    .foregroundColor(tint)
                    .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)

                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(Color(white: 0.6))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(white: 0.6))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(white: 0.15))
            )
        }
        .buttonStyle(.plain)
    }
}
