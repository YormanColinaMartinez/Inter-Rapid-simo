//
//  LocalitiesView.swift
//  Inter Rapidísimo
//
//  Created by mac on 25/12/25.
//

import SwiftUI

// MARK: - LocalitiesView

struct LocalitiesView: View {

    // MARK: - Properties
    
    @StateObject private var viewModel: LocalitiesViewModel

    // MARK: - Initialization
    
    init() {
        let api = APIClient()
        let repo = LocalitiesRepositoryImpl(api: api)
        _viewModel = StateObject(wrappedValue: LocalitiesViewModel(repo: repo))
    }

    // MARK: - Body
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView(Strings.Localities.loading)
            } else if let error = viewModel.error {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else if viewModel.items.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "mappin.slash")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text(Strings.Localities.empty)
                        .foregroundColor(.gray)
                }
                .padding()
            } else {
                List(viewModel.items, id: \.id) { loc in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(loc.nombreCompleto)
                            .font(.headline)
                        Text(loc.abreviacionCiudad)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle(Strings.Localities.title)
        .onAppear {
            viewModel.load()
        }
    }
}
