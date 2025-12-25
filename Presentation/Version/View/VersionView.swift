//
//  VersionView.swift
//  Inter Rapidísimo
//
//  Created by mac on 24/12/25.
//

import SwiftUI

struct VersionView: View {

    @StateObject var viewModel: VersionViewModel
    @State private var showAlert = false

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Validando versión...")
            } else if viewModel.isVersionValid || !viewModel.isVersionValid {
                LoginView()
            }
        }
        .padding()
        .onAppear {
            viewModel.check()
        }
        .onChange(of: viewModel.errorMessage) { _, newValue in
            showAlert = newValue != nil
        }
        .alert("Control de versión",
               isPresented: $showAlert,
               actions: {
                   Button("Aceptar", role: .cancel) { }
               },
               message: {
                   Text(viewModel.errorMessage ?? "")
               })
    }
}
