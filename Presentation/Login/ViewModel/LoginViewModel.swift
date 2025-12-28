//
//  LoginViewModel.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import Foundation

// MARK: - LoginViewModel

@MainActor
final class LoginViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    private let authRepo: AuthRepository
    private let userRepo: UserRepository
    
    // MARK: - Initialization
    
    init(authRepo: AuthRepository, userRepo: UserRepository) {
        self.authRepo = authRepo
        self.userRepo = userRepo
    }
    
    // MARK: - Public Methods
    
    func login(username: String, password: String) async {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = Strings.Login.emptyCredentialsError
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
