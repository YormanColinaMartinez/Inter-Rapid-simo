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
                //CameraTestView() Esta vista debe ser temporal y reemplazada por la vista que va a ir en su lugar , RECUERDATE YORMAN DE REEMPLAZAR ESTO Y EL FILE DONDE ESTA LA VISTA
                NavigationLink("📸 Test Cámara", destination: CameraTestView())
            }
            .navigationTitle("Bienvenido \(username)")
        }
    }
}
