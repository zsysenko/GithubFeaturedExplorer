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
    
    @Environment(\.verticalSizeClass) private var vSize
    
    private var repository: Repository {
        model.repository
    }
    
    var body: some View {
        VStack {
            headerView
                .padding()
            
            if vSize == .regular {
                languagesBlock
            }
            readmeBlock
            
            Spacer()
        }
        .frame(maxWidth: 800)
        .onAppear {
            Task {
                await model.load()
            }
        }
    }
    
    //MARK: - Languages block
    
    @ViewBuilder
    private var languagesBlock: some View {
        switch model.languagesState {
            case.sucsess(let languages):
                LanguagesView(languages: languages)
                    .padding(.horizontal)
                
            case .idle, .loading:
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray)
                    .frame(maxHeight: 80)
                    .padding()
                    .shimmering(active: true)
                
            case .error(_):
                EmptyView()
        }
    }
    
    //MARK: - Readme block
    
    @ViewBuilder
    private var readmeBlock: some View {
        switch model.readmeState {
            case.sucsess(let htmlString):
                WebView(htmlString: htmlString)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.horizontal)
                
            case .idle, .loading:
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray)
                    .padding(.horizontal)
                    .shimmering(active: true)
                
            case .error(_):
                ContentUnavailableView(
                    "Issues with loading readme file.",
                    systemImage: "icloud.slash"
                )
                .padding()
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 5) {
            RepoTitleView(
                repo: repository.name,
                owner: repository.owner.login
            )
            .font(.title3)
            
            if vSize == .regular {
                HStack {
                    PrivateBadge(isPrivate: repository.isPrivate)
                        .font(.callout)
                        .foregroundStyle(.gray)
                        .padding(.vertical, 5)
                    Spacer()
                }
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
                            .font(.caption)
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
