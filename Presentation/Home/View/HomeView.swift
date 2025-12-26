//
//  HomeView.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import SwiftUI

struct HomeView: View {

    let username: String

    var body: some View {
        NavigationView {
            List {
                NavigationLink("📋 Tablas", destination: TablesView())
                NavigationLink("📍 Localidades", destination: LocalitiesView())
            }
            .navigationTitle("Bienvenido \(username)")
        }
    }
}
