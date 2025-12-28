//
//  HomeView.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import SwiftUI

// MARK: - HomeView

struct HomeView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var session: SessionViewModel
    @StateObject private var viewModel = HomeViewModel()

    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // MARK: - App Header
                        appHeader
                        
                        // MARK: - Welcome Message
                        welcomeMessage
                        
                        // MARK: - User Information Card
                        if let user = viewModel.user {
                            userCard(user: user)
                        }

                        // MARK: - Navigation Cards
                        navigationCards
                        
                        Spacer()
                            .frame(height: 40)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 100)
                }
                
                // MARK: - Logout Button
                logoutButton
            }
            .navigationBarHidden(true)
            .preferredColorScheme(.dark)
            .onAppear {
                Task { await viewModel.loadUser() }
            }
        }
    }
    
    // MARK: - View Components
    
    private var appHeader: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.orange)
                    .frame(width: 40, height: 40)
                
                Text(Strings.App.logoSymbol)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            
            HStack(spacing: 4) {
                Text(Strings.App.nameInter)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white)
                
                Text(Strings.App.nameRapidisimo)
                    .font(.system(size: 20, weight: .bold))
                    .italic()
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
    
    private var welcomeMessage: some View {
        HStack {
            Text(Strings.Home.welcomeBack)
                .font(.system(size: 16))
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    private func userCard(user: User) -> some View {
        HStack(spacing: 16) {
            Image(systemName: "person.fill")
                .font(.system(size: 32))
                .foregroundColor(Color(white: 0.7))
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(Strings.Home.user)
                    .font(.system(size: 12))
                    .foregroundColor(Color(white: 0.6))
                
                Text(user.user)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                if !user.id.isEmpty {
                    Text("\(Strings.Home.identification): \(user.id)")
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
    
    private var navigationCards: some View {
        VStack(spacing: 12) {
            HomeModuleCard(
                title: Strings.Home.tablesTitle,
                subtitle: Strings.Home.tablesSubtitle,
                systemImage: "square.grid.2x2",
                tint: Color(red: 1.0, green: 0.84, blue: 0.0),
                destination: TablesView()
            )

            HomeModuleCard(
                title: Strings.Home.localitiesTitle,
                subtitle: Strings.Home.localitiesSubtitle,
                systemImage: "mappin.circle.fill",
                tint: Color(red: 0.4, green: 0.7, blue: 1.0),
                destination: LocalitiesView()
            )

            HomeModuleCard(
                title: Strings.Home.photosTitle,
                subtitle: Strings.Home.photosSubtitle,
                systemImage: "camera.fill",
                tint: Color(red: 0.0, green: 0.8, blue: 0.8),
                destination: PhotosListView()
            )
        }
        .padding(.horizontal, 20)
    }
    
    private var logoutButton: some View {
        VStack {
            Spacer()
            
            Button {
                Task { await session.logout() }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "power")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(Strings.Home.logout)
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
}
