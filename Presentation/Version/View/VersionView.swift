//
//  VersionView.swift
//  Inter Rapidísimo
//
//  Created by mac on 24/12/25.
//

import SwiftUI

struct VersionView: View {
    
    @StateObject var viewModel: VersionViewModel
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
        .alert(
            "Control de versión",
            isPresented: .constant(viewModel.errorMessage != nil),
            actions: {
                Button("Aceptar", role: .cancel) {}
            },
            message: {
                Text(viewModel.errorMessage ?? "")
            }
        )
    }
}
