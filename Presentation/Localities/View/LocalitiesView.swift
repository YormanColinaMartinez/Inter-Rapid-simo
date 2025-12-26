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
                Text(error).foregroundColor(.red)
            } else {
                List(viewModel.items, id: \.id) { loc in
                    Text(loc.name)
                }
            }
        }
        .navigationTitle("Localidades")
        .onAppear {
            viewModel.load()
        }
    }
}
