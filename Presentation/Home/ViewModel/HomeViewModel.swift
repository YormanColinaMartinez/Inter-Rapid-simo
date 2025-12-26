//
//  HomeViewModel.swift
//  Inter Rapidísimo
//
//  Created by mac on 26/12/25.
//

import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {

    @Published var user: User?
    @Published var errorMessage: String?

    func loadUser() async {
        do {
            user = try await SQLiteManager.shared.fetchUser()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func logout() async {
        do {
            try await SQLiteManager.shared.deleteUser()
            user = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
