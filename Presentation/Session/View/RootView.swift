//
//  RootView.swift
//  Inter Rapidísimo
//
//  Created by mac on 26/12/25.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject private var session: SessionViewModel
    @State private var versionValidated = false
    
    var body: some View {
        Group {
            if !versionValidated {
                VersionView(
                    viewModel: VersionViewModel(
                        repo: VersionRepositoryImpl(api: APIClient())
                    )
                ) {
                    versionValidated = true
                }
            } else {
                if session.isAuthenticated {
                    HomeView()
                } else {
                    LoginView()
                }
            }
        }
        .task {
            await session.loadSession()
        }
    }
}
