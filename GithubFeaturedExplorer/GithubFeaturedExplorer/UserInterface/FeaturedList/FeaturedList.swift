//
//  FeaturedList.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 04/06/2025.
//

import SwiftUI

struct FeaturedList: View {
    @Environment(FeaturedListModel.self) private var model
    
    var body: some View {
        VStack(spacing: 50) {
            headerView
            
            contentView
        }
        .task {
            await model.fetchFeaturedList()
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 10) {
            Text("Trending")
                .font(.title)
                .bold()
            
            Text("See what the GitHub community is most excited about this week")
                .multilineTextAlignment(.center)
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 10) {
            List(model.featuredList, rowContent: { repository in
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(repository.name)")
                        .foregroundStyle(.blue)
                    
                    +
                    
                    Text(" \\ \(repository.owner.login)")
                        .bold()
                        .foregroundStyle(.blue)
                        
                    Text(repository.description ?? "")
                }
                .frame(maxHeight: 200)
                
            })
        }
    }
}

#Preview {
    FeaturedList()
        .environment(
            FeaturedListModel(apiService: ApiService())
        )
}
