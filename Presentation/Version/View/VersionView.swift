//
//  VersionView.swift
//  Inter Rapidísimo
//
//  Created by mac on 24/12/25.
//

import SwiftUI

// MARK: - VersionView

struct VersionView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: VersionViewModel
    @State private var showAlert = false
    let onValidated: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView(Strings.Version.validating)
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
            Strings.Version.title,
            isPresented: $showAlert,
            actions: {
                Button(Strings.Common.accept, role: .cancel) {}
            },
            message: {
                Text(viewModel.errorMessage ?? "")
            }
        )
    }
}
