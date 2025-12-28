//
//  TablesView.swift
//  Inter Rapidísimo
//
//  Created by mac on 25/12/25.
//

import SwiftUI

// MARK: - TablesView

struct TablesView: View {

    // MARK: - Properties
    
    @StateObject private var viewModel: TablesViewModel

    // MARK: - Initialization
    
    init() {
        let api = APIClient()
        let remote = SchemaRepositoryImpl(api: api)
        let local = SchemaLocalRepositoryImpl()
        let sync = SchemaSyncService(remote: remote, local: local)

        _viewModel = StateObject(
            wrappedValue: TablesViewModel(syncService: sync, localRepo: local)
        )
    }

    // MARK: - Body
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView(Strings.Tables.loading)
            } else if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            } else if viewModel.tables.isEmpty {
                Text(Strings.Tables.empty)
            } else {
                List(viewModel.tables, id: \.nombreTabla) { table in
                    VStack(alignment: .leading) {
                        Text(table.nombreTabla).font(.headline)
                        if let desc = table.descripcion {
                            Text(desc).font(.subheadline)
                        }
                    }
                }
            }
        }
        .navigationTitle(Strings.Tables.title)
        .onAppear {
            viewModel.load()
        }
    }
}
