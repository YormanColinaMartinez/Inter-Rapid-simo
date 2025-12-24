//
//  LoginViewModel.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLoggedIn = false

    private let authRepo: AuthRepository
    private let userRepo: UserRepository

    init(authRepo: AuthRepository, userRepo: UserRepository) {
        self.authRepo = authRepo
        self.userRepo = userRepo
    }

    func login() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                let user = try await authRepo.login()
                try await userRepo.save(user: user)
                isLoggedIn = true
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
