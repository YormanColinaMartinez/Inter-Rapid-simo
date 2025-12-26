//
//  HomeView.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel = HomeViewModel()
    @State private var goToLogin = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                if let user = viewModel.user {
                    VStack(spacing: 8) {
                        Text("Bienvenido")
                            .font(.headline)

                        Text(user.name)
                            .font(.title2)
                            .bold()

                        Text("Usuario: \(user.user)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }

                Divider()

                List {
                    NavigationLink("📋 Tablas", destination: TablesView())
                    NavigationLink("📍 Localidades", destination: LocalitiesView())
                    NavigationLink("📸 Test Cámara", destination: CameraTestView())
                    NavigationLink("📸 Fotos", destination: PhotosListView())
                }
                .listStyle(.insetGrouped)

            }
            .navigationDestination(isPresented: $goToLogin) {
                LoginView()
            }
            .navigationTitle("Inicio")
            .onAppear {
                Task {
                    await viewModel.loadUser()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salir") {
                        Task {
                            await viewModel.logout()
                            goToLogin = true
                        }
                    }
                }
            }
        }
    }
}
