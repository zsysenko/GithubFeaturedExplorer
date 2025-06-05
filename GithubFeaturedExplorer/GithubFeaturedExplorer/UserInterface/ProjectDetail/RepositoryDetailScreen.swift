//
//  ProjectDetail.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 05/06/2025.
//

import SwiftUI

struct RepositoryDetailScreen: View {
    let repository: Repository
    
    var body: some View {
        Text(repository.fullName)
    }
}

#Preview {
    RepositoryDetailScreen(repository: Repository.mock)
}
