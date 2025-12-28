//
//  LoginView.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject private var session: SessionViewModel
    @StateObject private var viewModel: LoginViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    
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
        ZStack {
            // Dark background with subtle texture
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 32) {
                    // MARK: - App Header (Logo + Name)
                    VStack(spacing: 16) {
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
                        }
                        
                        // Title
                        Text("Iniciar Sesión")
                            .font(.system(size: 28, weight: .regular))
                            .foregroundColor(.white)
                    }
                    
                    // MARK: - Login Form Card
                    VStack(spacing: 20) {
                        // Username Field
                        HStack(spacing: 12) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 18))
                                .foregroundColor(Color(white: 0.6))
                                .frame(width: 24)
                            
                            TextField("Nombre de usuario", text: $username)
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
                                TextField("Contraseña", text: $password)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.white)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()
                            } else {
                                SecureField("Contraseña", text: $password)
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
                                Text("+")
                                    .font(.system(size: 20, weight: .bold))
                                Text("Ingresar")
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
                            .cornerRadius(12)
                        }
                        .disabled(viewModel.isLoading || username.isEmpty || password.isEmpty)
                        
                        // Forgot Password Link
                        Button {
                            // TODO: Implement forgot password
                        } label: {
                            Text("¿Olvidaste tu contraseña?")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(white: 0.15))
                    )
                    .padding(.horizontal, 24)
                    
                    // Error Message
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
}
