//
//  TablesViewModel.swift
//  Inter Rapidísimo
//
//  Created by mac on 25/12/25.
//

import Foundation

@MainActor
final class TablesViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var tables: [SchemaTableDTO] = []
    @Published var errorMessage: String?

    private let syncService: SchemaSyncService
    private let localRepo: SchemaLocalRepositoryImpl

    init(syncService: SchemaSyncService,
         localRepo: SchemaLocalRepositoryImpl) {
        self.syncService = syncService
        self.localRepo = localRepo
    }

    func load() {
        Task {
            isLoading = true
            do {
                try await syncService.sync()
                tables = try await localRepo.getAll()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
