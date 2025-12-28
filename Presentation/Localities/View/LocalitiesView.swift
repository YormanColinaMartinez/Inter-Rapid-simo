//
//  LocalitiesView.swift
//  Inter Rapidísimo
//
//  Created by mac on 25/12/25.
//

import SwiftUI

struct LocalitiesView: View {

    @StateObject private var viewModel: LocalitiesViewModel

    init() {
        let api = APIClient()
        let repo = LocalitiesRepositoryImpl(api: api)
        _viewModel = StateObject(wrappedValue: LocalitiesViewModel(repo: repo))
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Cargando localidades...")
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
                    Text("No hay localidades disponibles")
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
        .navigationTitle("Localidades")
        .onAppear {
            viewModel.load()
        }
    }
}
