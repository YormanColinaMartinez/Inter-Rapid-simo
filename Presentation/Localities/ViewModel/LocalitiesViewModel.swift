//
//  LocalitiesViewModel.swift
//  Inter Rapidísimo
//
//  Created by mac on 25/12/25.
//

import Foundation

@MainActor
final class LocalitiesViewModel: ObservableObject {

    @Published var items: [Locality] = []
    @Published var isLoading = false
    @Published var error: String?

    private let repo: LocalitiesRepository

    init(repo: LocalitiesRepository) {
        self.repo = repo
    }

    func load() {
        isLoading = true
        Task {
            do {
                items = try await repo.fetchRemote()
            } catch {
                #if DEBUG
                print("⚠️ Remote localities failed, loading local. Error:", error)
                #endif
                do {
                    items = try await repo.fetchLocal()
                    if items.isEmpty {
                        self.error = "No hay localidades disponibles."
                    }
                } catch {
                    self.error = error.localizedDescription
                }
            }
            isLoading = false
        }
    }

}
