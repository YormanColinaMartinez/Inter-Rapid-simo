//
//  HomeView.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var session: SessionViewModel
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                // Dark background
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // MARK: - App Header (Logo + Name)
                        HStack(spacing: 12) {
                            // Logo "S" naranja
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.orange)
                                    .frame(width: 40, height: 40)
                                
                                Text("S")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            HStack(spacing: 4) {
                                Text("Inter")
                                    .font(.system(size: 20, weight: .regular))
                                    .foregroundColor(.white)
                                
                                Text("Rapidisimo")
                                    .font(.system(size: 20, weight: .bold))
                                    .italic()
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        // MARK: - Welcome Message
                        HStack {
                            Text("Bienvenido de nuevo")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: - User Information Card
                        if let user = viewModel.user {
                            HStack(spacing: 16) {
                                // User icon
                                Image(systemName: "person.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(Color(white: 0.7))
                                    .frame(width: 50, height: 50)
                                
                                // User info
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Usuario")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(white: 0.6))
                                    
                                    Text(user.user)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    if !user.id.isEmpty {
                                        Text("Identificación: \(user.id)")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color(white: 0.6))
                                    }
                                    
                                    Text(user.name)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(white: 0.15))
                            )
                            .padding(.horizontal, 20)
                        }

                        // MARK: - Navigation Cards
                        VStack(spacing: 12) {
                            HomeModuleCard(
                                title: "Tablas",
                                subtitle: "Consulta y gestión de esquemas de datos",
                                systemImage: "square.grid.2x2",
                                tint: Color(red: 1.0, green: 0.84, blue: 0.0), // Golden yellow
                                destination: TablesView()
                            )

                            HomeModuleCard(
                                title: "Localidades",
                                subtitle: "Visualización de localidades disponibles",
                                systemImage: "mappin.circle.fill",
                                tint: Color(red: 0.4, green: 0.7, blue: 1.0), // Light blue
                                destination: LocalitiesView()
                            )

                            HomeModuleCard(
                                title: "Fotos",
                                subtitle: "Captura y almacenamiento de imágenes",
                                systemImage: "camera.fill",
                                tint: Color(red: 0.0, green: 0.8, blue: 0.8), // Teal
                                destination: PhotosListView()
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Spacer before logout button
                        Spacer()
                            .frame(height: 40)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 100) // Space for logout button
                }
                
                // MARK: - Logout Button (Fixed at bottom)
                VStack {
                    Spacer()
                    
                    Button {
                        Task { await session.logout() }
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "power")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Cerrar Sesión")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(white: 0.15))
                        )
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 34)
                }
            }
            .navigationBarHidden(true)
            .preferredColorScheme(.dark)
            .onAppear {
                Task { await viewModel.loadUser() }
            }
        }
    }
}
