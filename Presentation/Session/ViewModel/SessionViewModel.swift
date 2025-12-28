//
//  SessionViewModel.swift
//  Inter Rapidísimo
//
//  Created by mac on 26/12/25.
//

import Foundation

@MainActor
final class SessionViewModel: ObservableObject {

    @Published var isAuthenticated = false

    func loadSession() async {
        let user = try? await SQLiteManager.shared.fetchUser()
        isAuthenticated = user != nil
    }

    func logout() async {
        try? await SQLiteManager.shared.deleteUser()
        isAuthenticated = false
    }
}
