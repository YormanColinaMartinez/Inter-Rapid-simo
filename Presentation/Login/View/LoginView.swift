//
//  LoginView.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import SwiftUI

struct LoginView: View {

    @StateObject var viewModel: LoginViewModel

    init() {
        let api = APIClient()
        let authRepo = AuthRepositoryImpl(api: api)
        let userRepo = UserRepositoryImpl()
        _viewModel = StateObject(wrappedValue:
            LoginViewModel(authRepo: authRepo, userRepo: userRepo)
        )
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Login")
                .font(.title)

            if viewModel.isLoading {
                ProgressView()
            }

            if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            }

            Button("Iniciar sesión") {
                viewModel.login()
            }
            .disabled(viewModel.isLoading)

            NavigationLink(
                destination: HomeView(),
                isActive: $viewModel.isLoggedIn
            ) {
                EmptyView()
            }
        }
        .padding()
    }
}
