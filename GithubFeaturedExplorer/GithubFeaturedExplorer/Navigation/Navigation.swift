//
//  Navigation.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 05/06/2025.
//

import Foundation
import SwiftUI

enum NavigationType: Hashable {
    case push(NavigationRoute)
    case pop(NavigationRoute)
}

extension EnvironmentValues {
    @Entry var navigate: NavigateAction = NavigateAction(action: {_ in })
}

extension View {
    func onNavigate(_ action: @escaping NavigateAction.Action) -> some View {
        self.environment(\.navigate, NavigateAction(action: action))
    }
}

struct NavigateAction {
    typealias Action = (NavigationType) -> ()
    
    let action: Action
    func callAsFunction(_ navigationType: NavigationType) {
        action(navigationType)
    }
}
