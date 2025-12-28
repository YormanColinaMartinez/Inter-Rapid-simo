//
//  LoginView.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject private var session: SessionViewModel
    @StateObject private var viewModel: LoginViewModel
    
    init() {
        let api = APIClient()
        let authRepo = AuthRepositoryImpl(api: api)
        let userRepo = UserRepositoryImpl()
        _viewModel = StateObject(
            wrappedValue: LoginViewModel(
                authRepo: authRepo,
                userRepo: userRepo
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            }
            
            Button("Iniciar sesión") {
                Task {
                    await viewModel.login()
                    await session.loadSession()
                }
            }
        }
        .padding()
    }
}
