//
//  HomeView.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import SwiftUI

struct HomeView: View {
    @State private var user: User?

    var body: some View {
        VStack {
            if let user {
                Text(user.name)
                Text(user.id)
            } else {
                Text("Sin usuario")
            }
        }
        .task {
            let repo = UserRepositoryImpl()
            user = try? await repo.getUser()
        }
    }
}

