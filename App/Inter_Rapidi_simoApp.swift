//
//  Inter_Rapidi_simoApp.swift
//  Inter Rapidísimo
//
//  Created by mac on 23/12/25.
//

import SwiftUI

@main
struct Inter_Rapidi_simoApp: App {
    
    init() {
        _ = SQLiteManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                let api = APIClient()
                let repo = VersionRepositoryImpl(api: api)
                let vm = VersionViewModel(repo: repo)
                
                VersionView(viewModel: vm)
            }
        }
    }
}
