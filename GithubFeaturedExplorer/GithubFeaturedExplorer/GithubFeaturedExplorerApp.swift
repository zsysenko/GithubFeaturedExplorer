//
//  GithubFeaturedExplorerApp.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 04/06/2025.
//

import SwiftUI
import SwiftData

enum NavigationRoute: Hashable {
    case featuredRepoList
    case repoDetail(repository: Repository)
}

@main
struct GithubFeaturedExplorerApp: App {
    @AppStorage("appearance") private var appearance: Appearance = .unspecified
    
    @State private var navigationRoutes: [NavigationRoute] = []

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationRoutes) {
                screenForRoute(.featuredRepoList)
                    .navigationDestination(for: NavigationRoute.self) { route in
                        screenForRoute(route)
                    }
            }
            .onNavigate { navigationType in
                perfomNavigation(for: navigationType)
            }
            .onAppear {
                setupTheme()
            }
        }
    }
    
    @ViewBuilder
    private func screenForRoute( _ route: NavigationRoute) -> some View {
        switch route {
            case .featuredRepoList:
                
                let viewModel = FeaturedListModel()
                FeaturedListScreen(viewModel: viewModel)
                
            case .repoDetail(let repository):
                let viewModel = RepositoryDetailModel(repository: repository)
                RepositoryDetailScreen()
                    .environment(viewModel)
        }
    }
    
    private func perfomNavigation(for navigationType: NavigationType) {
        switch navigationType {
            case .push(let route):
                navigationRoutes.append(route)
                
            case .pop(let route):
                if route == .featuredRepoList {
                    navigationRoutes = []
                    
                } else {
                    guard let index = navigationRoutes.firstIndex(where: { $0 == route }) else { return }
                    navigationRoutes = Array(navigationRoutes.prefix(upTo: index + 1))
                }
        }
    }
    
    private func setupTheme() {
        let window = UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first
        
        window?.overrideUserInterfaceStyle = appearance.userInterfaceStyle
    }
}
