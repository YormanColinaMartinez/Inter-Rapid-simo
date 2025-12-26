//
//  TablesView.swift
//  Inter Rapidísimo
//
//  Created by mac on 25/12/25.
//

import SwiftUI

struct TablesView: View {

    @StateObject private var viewModel: TablesViewModel

    init() {
        let api = APIClient()
        let remote = SchemaRepositoryImpl(api: api)
        let local = SchemaLocalRepositoryImpl()
        let sync = SchemaSyncService(remote: remote, local: local)

        _viewModel = StateObject(
            wrappedValue: TablesViewModel(syncService: sync, localRepo: local)
        )
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Cargando esquema...")
            } else if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            } else if viewModel.tables.isEmpty {
                Text("No hay tablas para mostrar.")
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
        .navigationTitle("Tablas")
        .onAppear {
            viewModel.load()
        }
    }
}
