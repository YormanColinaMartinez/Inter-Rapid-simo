//
//  LoginView.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import SwiftUI

// MARK: - LoginView

struct LoginView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var session: SessionViewModel
    @StateObject private var viewModel: LoginViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    
    // MARK: - Initialization
    
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
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 32) {
                    // MARK: - App Header
                    appHeader
                    
                    // MARK: - Login Form Card
                    loginFormCard
                    
                    // MARK: - Error Message
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                }
                
                Spacer()
                
                // MARK: - Loading Indicator
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                        .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .preferredColorScheme(.dark)
    }
    
    // MARK: - View Components
    
    private var appHeader: some View {
        VStack(spacing: 16) {
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
            }
            
            Text(Strings.Login.title)
                .font(.system(size: 28, weight: .regular))
                .foregroundColor(.white)
        }
    }
    
    private var loginFormCard: some View {
        VStack(spacing: 20) {
            // Username Field
            HStack(spacing: 12) {
                Image(systemName: "person.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Color(white: 0.6))
                    .frame(width: 24)
                
                TextField(Strings.Login.usernamePlaceholder, text: $username)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.2))
            )
            
            // Password Field
            HStack(spacing: 12) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Color(white: 0.6))
                    .frame(width: 24)
                
                if showPassword {
                    TextField(Strings.Login.passwordPlaceholder, text: $password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                } else {
                    SecureField(Strings.Login.passwordPlaceholder, text: $password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                
                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color(white: 0.6))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.2))
            )
            
            // Login Button
            Button {
                Task {
                    await viewModel.login(username: username, password: password)
                    if viewModel.errorMessage == nil {
                        await session.loadSession()
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Text(Strings.Login.loginButtonPrefix)
                        .font(.system(size: 20, weight: .bold))
                    Text(Strings.Login.loginButton)
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.2, green: 0.5, blue: 1.0),
                            Color(red: 0.0, green: 0.4, blue: 0.9)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 150)
                .cornerRadius(12)
            }
            .disabled(viewModel.isLoading || username.isEmpty || password.isEmpty)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(white: 0.15))
        )
        .padding(.horizontal, 24)
    }
}
