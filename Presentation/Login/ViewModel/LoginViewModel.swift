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
    
    private let authRepo: AuthRepository
    private let userRepo: UserRepository
    
    init(authRepo: AuthRepository, userRepo: UserRepository) {
        self.authRepo = authRepo
        self.userRepo = userRepo
    }
    
    func login(username: String, password: String) async {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Por favor ingresa usuario y contraseña"
            return
        }
        
        isLoading = true
        errorMessage = nil
        do {
            let user = try await authRepo.login(username: username, password: password)
            try await userRepo.save(user: user)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
