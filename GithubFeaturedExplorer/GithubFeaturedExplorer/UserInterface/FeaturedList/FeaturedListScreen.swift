//
//  FeaturedList.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 04/06/2025.
//

import SwiftUI

enum ActiveFilter: Identifiable  {
    var id: UUID {
        UUID()
    }
    
    case dateRangeFilter
    case languageFilter
}

struct FeaturedListScreen: View {
    @Environment(FeaturedListModel.self)  private var model
    @Environment(\.navigate) private var navigate
    
    @State private var selectedFilter: ActiveFilter? = nil
    @State private var isSettingsOpened = false
    
    var body: some View {
        VStack {
            headerView
            filtersControll
                .padding(.top, 10)
            
            if model.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
                
                Spacer()
            } else {
                contentView
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isSettingsOpened.toggle()
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $isSettingsOpened, content: {
            SettingsScreen()
        })
        .sheet(item: $selectedFilter, content: { selectedFilter in
            switch selectedFilter {
                case .dateRangeFilter:
                    DateRangePickerScreen(
                        selectedRange:
                            Binding(
                                get: { model.selectedDataRange },
                                set: { model.selectedDataRange = $0 }
                            ),
                        onDismiss: {
                            self.selectedFilter = nil
                        }
                    )
                    
                case .languageFilter:
                    LanguageFilterScreen(
                        languages: model.languages,
                        selectedLanguage: 
                            Binding(
                                get: { model.selectedLanguage },
                                set: { model.selectedLanguage = $0 }
                            ),
                        onDismiss: {
                            self.selectedFilter = nil
                        }
                    )
            }
        })
        .onChange(of: model.selectedDataRange, initial: true, { old, new in
            if model.featuredList.isEmpty || old != new {
                Task {
                    await model.fetchFeaturedList()
                }
            }
        })
    }
    
    private var headerView: some View {
        VStack(spacing: 5) {
            Text("Trending")
                .font(.title)
                .bold()
            
            Text("See what the GitHub community is most excited about.")
                .multilineTextAlignment(.center)
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 10) {
            List(model.filteredList, rowContent: { repository in
                RepositoryCell(repository: repository)
                    .onTapGesture {
                        navigate(.push(.repoDetail(repository: repository)))
                    }
            })
            .frame(maxWidth: 700, alignment: .center)
        }
        .frame(maxWidth: .infinity)
        .background(
            Color(uiColor: UIColor.systemGroupedBackground)
        )
    }
    
    private var filtersControll: some View {
        HStack(spacing: 20) {
            FilterControlView(
                selectedValue: model.selectedDataRange.title,
                isExpanded: selectedFilter == .dateRangeFilter
            ) {
                selectedFilter = .dateRangeFilter
            }
            
            FilterControlView(
                selectedValue: model.selectedLanguage ?? "All Languages",
                isExpanded: selectedFilter == .languageFilter
            ) {
                selectedFilter = .languageFilter
            }
        }
    }
}

struct RepositoryCell: View {
    
    let repository: Repository
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RepoTitleView(
                repo: repository.name,
                owner: repository.owner.login
            )
            
            Text(repository.description ?? " - ")
                .font(.caption)
            
            HStack(spacing: 10) {
                Text(repository.language ?? "")
                    .bold()
                
                StarsView(starsCount: repository.stargazersCount)
                ForksView(forkCount: repository.forksCount)

                Spacer()
                
                AvatarView(url: repository.owner.avatarUrl)
                    .frame(maxWidth: 40)
            }
            .font(.caption)
            
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    FeaturedListScreen()
        .environment(
            FeaturedListModel(apiService: ApiService())
        )
}
