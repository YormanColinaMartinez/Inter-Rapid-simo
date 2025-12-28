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

    func loadUser() async {
        user = try? await SQLiteManager.shared.fetchUser()
    }
}
