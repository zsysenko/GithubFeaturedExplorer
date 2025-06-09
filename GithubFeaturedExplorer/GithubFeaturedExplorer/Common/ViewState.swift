//
//  ViewState.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 08/06/2025.
//

import Foundation

enum ViewState<T> {
    case idle
    case loading
    case sucsess(T)
    case error(Error)
}
