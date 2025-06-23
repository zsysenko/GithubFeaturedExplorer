//
//  FiltersViewModel.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 22/06/2025.
//

import SwiftUI
 
protocol FilterObjectProtocol: Equatable, Hashable {
    var title: String { get }
}

extension String: FilterObjectProtocol {
    var title: String {
        return self
    }
}

final class FiltersViewModel<Object: FilterObjectProtocol> {
    
    let objects: [Object]
    var selectedObject: Object?
    
    var isOptionalAvailable: Bool
    var isSearchAvailable: Bool = false
    
    init(
        objects: [Object],
        selectedObject: Object?,
        isOptionalAvailable: Bool = false
    ) {
        self.objects = objects
        self.isOptionalAvailable = isOptionalAvailable
        self.selectedObject = selectedObject
    }
}
