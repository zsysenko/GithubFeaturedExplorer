//
//  GithubFeaturedExplorerApp.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 04/06/2025.
//

import SwiftUI
import SwiftData

@main
struct GithubFeaturedExplorerApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
    
    private var paths: [NavigationPath] = []

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                FeaturedList()
            }
        }
        .environment(FeaturedListModel(apiService: ApiService()))
//        .modelContainer(sharedModelContainer)
    }
}
