//
//  ProjectDetail.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 05/06/2025.
//

import SwiftUI
import Observation

struct RepositoryDetailScreen: View {
    @Environment(RepositoryDetailModel.self) private var model
    
    private var repository: Repository {
        model.repository
    }
    
    var body: some View {
        VStack {
            contentView
                .padding()
            
            switch model.languagesState {
                case.sucsess(let languages):
                    LanguagesView(languages: languages)
                        .padding(.horizontal)
                    
                case .idle, .loading:
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray)
                        .shimmering(active: true)
                    
                case .error(_):
                    EmptyView()
            }
            
            switch model.readmeState {
                case.sucsess(let htmlString):
                    WebView(htmlString: htmlString)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                        .border(.gray)
                    
                case .idle, .loading:
                    ProgressView("Loading")
                    
                case .error(_):
                    VStack {
                        Text("No result. try again later.")
                    }
            }
            Spacer()
        }
        .onAppear {
            Task {
                await model.load()
            }
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 5) {
            RepoTitleView(
                repo: repository.name,
                owner: repository.owner.login
            )
            .font(.title3)
            
            HStack {
                PrivateBadge(isPrivate: repository.isPrivate)
                    .font(.callout)
                    .foregroundStyle(.gray)
                Spacer()
            }
            
            HStack {
                Text(model.repository.description ?? " - ")
                    .font(.subheadline)
                Spacer()
            }
            
            VStack(spacing: 5) {
                if let homepage = repository.homepage, homepage.count > 0 {
                    HStack {
                        HomepageBadge(homepage: homepage)
                        Spacer()
                    }
                }
                
                HStack(spacing: 10) {
                    StarsView(starsCount: repository.stargazersCount)
                    ForksView(forkCount: repository.forksCount)
                    WatchersView(watchersCount: repository.watchersCount)
                    
                    Spacer()
                    
                    if let license = repository.license {
                        LicenseBadge(license: license.name)
                    }

                }
                .font(.subheadline)
                .foregroundStyle(.gray)
            }
            .font(.callout)
        }
    }
}

#Preview {
    RepositoryDetailScreen()
        .environment(RepositoryDetailModel(repository: Repository.mock))
}
