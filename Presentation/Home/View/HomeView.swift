//
//  HomeView.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var session: SessionViewModel
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {

                    // MARK: - Header
                    if let user = viewModel.user {
                        VStack(spacing: 6) {
                            Text("Bienvenido")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            Text(user.name)
                                .font(.title)
                                .fontWeight(.semibold)

                            Text(user.user)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                        )
                        .padding(.horizontal)
                    }

                    // MARK: - Modules
                    VStack(spacing: 16) {

                        HomeCard(
                            title: "Tablas",
                            subtitle: "Estructura y datos locales",
                            systemImage: "list.bullet.rectangle",
                            destination: TablesView()
                        )

                        HomeCard(
                            title: "Localidades",
                            subtitle: "Consulta y persistencia",
                            systemImage: "mappin.and.ellipse",
                            destination: LocalitiesView()
                        )

                        HomeCard(
                            title: "Fotos",
                            subtitle: "Captura y almacenamiento",
                            systemImage: "camera.on.rectangle",
                            destination: PhotosListView()
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 24)
            }
            .navigationTitle("Inicio")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        Task {
                            await session.logout()
                        }
                    } label: {
                        Image(systemName: "arrow.right.square")
                    } 
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadUser()
                }
            }
        }
    }
}
