//
//  Inter_Rapidi_simoApp.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.r
//

import SwiftUI

@main
struct Inter_Rapidi_simoApp: App {
    @StateObject private var session = SessionViewModel()

    init() {
        _ = SQLiteManager.shared
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
        }
    }
}
