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
    let onValidated: () -> Void
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Validando versión...")
            } 
        }
        .onAppear {
            viewModel.check()
        }
        .onChange(of: viewModel.isVersionValid) { _, valid in
            if valid {
                onValidated()
            }
        }
        .onChange(of: viewModel.errorMessage) { _, message in
            if message != nil {
                showAlert = true
            }
        }
        .alert(
            "Control de versión",
            isPresented: $showAlert,
            actions: {
                Button("Aceptar", role: .cancel) {}
            },
            message: {
                Text(viewModel.errorMessage ?? "")
            }
        )
    }
}
